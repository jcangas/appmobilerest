module.exports = {
  pathToDocsifyEntryPoint: "./docs",
  "mainMdFilename": "intro.md",
  contents: [ "docs/_sidebar.md" ], // array of "table of contents" files path
  pathToPublic: "pdf/document.pdf", // path where pdf will stored
  removeTemp: false, // remove generated .md and .html or not
  emulateMedia: "screen", // mediaType, emulating by puppeteer for rendering pdf, 'print' by default (reference: https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pageemulatemediamediatype)
}
