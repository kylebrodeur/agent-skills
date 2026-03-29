/** @type {import('dependency-cruiser').IConfiguration} */
module.exports = {
  forbidden: [
    {
      name: "no-circular",
      severity: "error",
      comment: "Circular dependencies cause hard-to-debug initialization issues",
      from: {},
      to: { circular: true },
    },
    {
      name: "no-orphans",
      severity: "warn",
      comment: "Orphan files should be deleted or given a purpose",
      from: { path: "^src/", pathNot: ["^src/index.ts", "^src/main.ts"] },
      to: { orphans: true },
    },
  ],
  options: {
    doNotFollow: {
      path: "node_modules",
    },
    tsConfig: {
      fileName: "tsconfig.json",
    },
    reporterOptions: {
      dot: {
        theme: {
          graph: { rankdir: "TB", splines: "ortho" },
          node: { fontname: "Helvetica", fontsize: "11", shape: "box" },
          edge: { arrowhead: "open", arrowsize: "0.6" },
        },
      },
    },
  },
};
