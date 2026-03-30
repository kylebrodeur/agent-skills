#!/usr/bin/env node
/**
 * Agent Skills CLI
 * Install and manage codebase analysis skills
 */

const { spawn } = require('child_process');
const { resolve, join } = require('path');
const { existsSync } = require('fs');

const PKG_ROOT = resolve(__dirname, '..');
const SCRIPTS_DIR = join(PKG_ROOT, 'scripts');

function runScript(scriptName, args = []) {
  const scriptPath = join(SCRIPTS_DIR, scriptName);

  if (!existsSync(scriptPath)) {
    console.error(`Error: Script not found: ${scriptName}`);
    process.exit(1);
  }

  const cmd = process.platform === 'win32' ? 'cmd.exe' : '/bin/bash';
  const cmdArgs = process.platform === 'win32'
    ? ['/c', scriptPath, ...args]
    : [scriptPath, ...args];

  const child = spawn(cmd, cmdArgs, { stdio: 'inherit' });

  child.on('close', (code) => {
    process.exit(code);
  });
}

function showHelp() {
  console.log(`
Agent Skills CLI - Install and manage codebase analysis

Usage: npx agent-skills <command>

Commands:
  install    Install agent skills to current project
  check      Check if config files are present
  help       Show this help message

Examples:
  npx agent-skills install    # Run setup script
  npx agent-skills check      # Verify installation

After installation, use pnpm scripts:
  pnpm analyze:all            # Run all analyses
  pnpm analyze:dead           # Find dead code
  pnpm analyze:dupes          # Find duplicate code
  pnpm analyze:deps:validate  # Check architecture
`);
}

function checkConfigs() {
  const requiredFiles = ['.jscpd.json', 'knip.json', '.dependency-cruiser.cjs'];
  const missing = requiredFiles.filter(file => !existsSync(file));

  if (missing.length === 0) {
    console.log('✓ All config files present');
    console.log('  - .jscpd.json');
    console.log('  - knip.json');
    console.log('  - .dependency-cruiser.cjs');
    process.exit(0);
  } else {
    console.log('✗ Missing config files:');
    missing.forEach(file => console.log(`  - ${file}`));
    console.log('\nRun: npx agent-skills install');
    process.exit(1);
  }
}

// Parse command line args
const args = process.argv.slice(2);
const command = args[0];

switch (command) {
  case 'install':
    runScript('setup.sh');
    break;
  case 'check':
    checkConfigs();
    break;
  case 'help':
  case '--help':
  case '-h':
  default:
    showHelp();
}
