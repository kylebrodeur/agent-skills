#!/usr/bin/env bash
# Setup script for codebase analysis tools
# Usage: bash packages/analysis-agent/scripts/setup.sh

set -e

echo "=== Setting up codebase analysis tools ==="

# Check for pnpm
if ! command -v pnpm &> /dev/null; then
  echo "Error: pnpm is not installed"
  echo "Install with: npm install -g pnpm"
  exit 1
fi

# Create config files if they don't exist
create_configs() {
  echo ""
  echo "Creating configuration files..."

  # Copy templates if they don't exist
  if [ -f "knip.json" ]; then
    echo "  knip.json already exists - skipping"
  else
    cp packages/analysis-agent/templates/knip.json knip.json 2>/dev/null || echo "  knip.json template not found"
    echo "  Created knip.json"
  fi

  if [ -f ".jscpd.json" ]; then
    echo "  .jscpd.json already exists - skipping"
  else
    cp packages/analysis-agent/templates/jscpd.json .jscpd.json 2>/dev/null || echo "  .jscpd.json template not found"
    echo "  Created .jscpd.json"
  fi

  if [ -f ".dependency-cruiser.cjs" ]; then
    echo "  .dependency-cruiser.cjs already exists - skipping"
  else
    cp packages/analysis-agent/templates/depcruise.cjs .dependency-cruiser.cjs 2>/dev/null || echo "  .dependency-cruiser.cjs template not found"
    echo "  Created .dependency-cruiser.cjs"
  fi
}

# Add scripts to package.json if not present
add_scripts() {
  echo ""
  echo "Adding pnpm scripts to package.json..."

  if [ ! -f "package.json" ]; then
    echo "  package.json not found - skipping script addition"
    return
  fi

  # Check if analyze scripts already exist
  if grep -q 'analyze:' package.json; then
    echo "  Analyze scripts already exist in package.json - skipping"
  else
    echo "  Adding analyze scripts to package.json"
    # Use node to safely add scripts to package.json
    node -e "
      const fs = require('fs');
      const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
      pkg.scripts = pkg.scripts || {};
      pkg.scripts['analyze:deps:validate'] = 'depcruise src --config .dependency-cruiser.cjs --output-type err';
      pkg.scripts['analyze:deps:graph'] = 'depcruise src --config .dependency-cruiser.cjs --output-type dot | dot -T svg > /tmp/dep-graph.svg && open /tmp/dep-graph.svg';
      pkg.scripts['analyze:dead'] = 'knip';
      pkg.scripts['analyze:dead:exports'] = 'knip --reporter compact --include exports,types';
      pkg.scripts['analyze:dupes'] = 'jscpd src';
      pkg.scripts['analyze:all'] = 'pnpm run analyze:deps:validate && pnpm run analyze:dead && pnpm run analyze:dupes';
      fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
    "
  fi
}

# Install dev dependencies
install_deps() {
  echo ""
  echo "Installing development dependencies..."

  # Add required dependencies if not present
  node -e "
    const fs = require('fs');
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

    const deps = {
      'dependency-cruiser': '^17.3.8',
      'jscpd': '^4.0.8',
      'knip': '^5.85.0'
    };

    const devDeps = pkg.devDependencies || {};

    let added = 0;
    for (const [name, version] of Object.entries(deps)) {
      if (!devDeps[name]) {
        devDeps[name] = version;
        added++;
        console.log('  Added ' + name + ' ' + version);
      }
    }

    if (added > 0) {
      pkg.devDependencies = devDeps;
      fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
      console.log('  package.json updated');
    } else {
      console.log('  All dependencies already installed');
    }
  "
}

# Run the setup steps
create_configs
add_scripts
install_deps

echo ""
echo "=== Setup complete ==="
echo ""
echo "Next steps:"
echo "  1. Run: pnpm install"
echo "  2. Run: pnpm analyze:all"
echo "  3. Review output and update templates/*.json if needed"
