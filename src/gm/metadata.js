// Copyright (c) <%= grunt.template.today('yyyy') %>, <%= pkg.author.name %>. (MIT Licensed)
// ==UserScript==
// @name          <%= pkg.name %>
// @namespace     http://github.com/smilekzs
// @version       <%= pkg.version %>
// @description   <%= pkg.description %>
// @grant         GM_xmlhttpRequest
// @include       *://*.tsinghua.edu.cn*bks_yxkccj*
// @include       *://*.tsinghua.edu.cn*yjs_yxkccj*
// ==/UserScript==
// vim: set nowrap ft= :

// http://stackoverflow.com/questions/4190442/run-greasemonkey-script-only-once-per-page-load
// if (window.top != window.self) return;  //don't run on frames or iframes
