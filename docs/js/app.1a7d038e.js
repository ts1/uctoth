(function(t){function e(e){for(var r,o,u=e[0],s=e[1],c=e[2],f=0,d=[];f<u.length;f++)o=u[f],a[o]&&d.push(a[o][0]),a[o]=0;for(r in s)Object.prototype.hasOwnProperty.call(s,r)&&(t[r]=s[r]);l&&l(e);while(d.length)d.shift()();return i.push.apply(i,c||[]),n()}function n(){for(var t,e=0;e<i.length;e++){for(var n=i[e],r=!0,u=1;u<n.length;u++){var s=n[u];0!==a[s]&&(r=!1)}r&&(i.splice(e--,1),t=o(o.s=n[0]))}return t}var r={},a={app:0},i=[];function o(e){if(r[e])return r[e].exports;var n=r[e]={i:e,l:!1,exports:{}};return t[e].call(n.exports,n,n.exports,o),n.l=!0,n.exports}o.m=t,o.c=r,o.d=function(t,e,n){o.o(t,e)||Object.defineProperty(t,e,{enumerable:!0,get:n})},o.r=function(t){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},o.t=function(t,e){if(1&e&&(t=o(t)),8&e)return t;if(4&e&&"object"===typeof t&&t&&t.__esModule)return t;var n=Object.create(null);if(o.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var r in t)o.d(n,r,function(e){return t[e]}.bind(null,r));return n},o.n=function(t){var e=t&&t.__esModule?function(){return t["default"]}:function(){return t};return o.d(e,"a",e),e},o.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},o.p="/uctoth/";var u=window["webpackJsonp"]=window["webpackJsonp"]||[],s=u.push.bind(u);u.push=e,u=u.slice();for(var c=0;c<u.length;c++)e(u[c]);var l=s;i.push([0,"chunk-vendors"]),n()})({0:function(t,e,n){t.exports=n("56d7")},"0130":function(t,e,n){"use strict";n.r(e);var r=n("89c4"),a=n.n(r);for(var i in r)"default"!==i&&function(t){n.d(e,t,function(){return r[t]})}(i);e["default"]=a.a},"03a8":function(t,e,n){},"03cd":function(t,e,n){},1048:function(t,e,n){},"1f3d":function(t,e,n){"use strict";var r=n("1048"),a=n.n(r);a.a},2375:function(t,e,n){"use strict";n.r(e);var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("svg",{staticClass:"spinner",attrs:{viewBox:"0 0 100 100"}},[n("circle",{attrs:{cx:"50",cy:"50",fill:"none",stroke:"currentColor","stroke-width":"7",r:"35","stroke-dasharray":"200 20"}})])},a=[],i=(n("3e51"),n("2877")),o={},u=Object(i["a"])(o,r,a,!1,null,"2aca0085",null);u.options.__file="Spinner.vue";e["default"]=u.exports},"25e0":function(t,e,n){"use strict";n.r(e);var r=n("48e5"),a=n("e2ec");for(var i in a)"default"!==i&&function(t){n.d(e,t,function(){return a[t]})}(i);n("bdd9");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"0bb43e85",null);u.options.__file="Game.vue",e["default"]=u.exports},"27c5":function(t,e,n){"use strict";n.r(e);var r=n("3f21"),a=n("f571");for(var i in a)"default"!==i&&function(t){n.d(e,t,function(){return a[t]})}(i);n("5d48");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"6a8b899b",null);u.options.__file="Setting.vue",e["default"]=u.exports},"2a7d":function(t,e,n){"use strict";n.r(e);var r=n("bc83"),a=n("89a8");for(var i in a)"default"!==i&&function(t){n.d(e,t,function(){return a[t]})}(i);n("7d37");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"4ba721ed",null);u.options.__file="Button.vue",e["default"]=u.exports},"2a90":function(t,e,n){"use strict";var r=n("4ea4");Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("097d"),n("494d");var a=r(n("27c5")),i=r(n("25e0")),o={name:"app",data:function(){return{mode:"setting",color:null,level:null,guide:null}},methods:{start:function(t,e,n){return this.color=t,this.level=e,this.guide=n,this.mode="game"},back:function(){return this.mode="setting"}},components:{Setting:a.default,Game:i.default}};e.default=o},"2ba8":function(t,e,n){"use strict";var r=n("4ea4");Object.defineProperty(e,"__esModule",{value:!0}),e.default=l,e.mute=e.is_muted=e.is_supported=void 0,n("7f7f"),n("96cf");var a,i,o,u,s,c=r(n("1da1"));function l(t){return f.apply(this,arguments)}function f(){return f=(0,c.default)(regeneratorRuntime.mark(function t(e){var n,r;return regeneratorRuntime.wrap(function(t){while(1)switch(t.prev=t.next){case 0:if(i){t.next=2;break}return t.abrupt("return");case 2:if(!u){t.next=4;break}return t.abrupt("return");case 4:if(n=s[e],n){t.next=7;break}throw new Error("sound ".concat(e," is not loaded"));case 7:return r=i.createBufferSource(),r.loop=!1,t.next=11,n;case 11:return r.buffer=t.sent,r.connect(i.destination),t.abrupt("return",r.start(0));case 14:case"end":return t.stop()}},t,this)})),f.apply(this,arguments)}n("551c"),n("cadf"),n("097d"),s={},i=null,u=!1,a=window.AudioContext||window.webkitAudioContext,a&&(i=new a,o=function(t){return new Promise(function(e,n){var r;return r=new XMLHttpRequest,r.open("GET",t),r.responseType="arraybuffer",r.onload=function(){return 200===r.status?i.decodeAudioData(r.response,function(t){return e(t)}):(console.dir(r),n(new Error("error loading ".concat(t))))},r.send()})},s.move=o(n("cff9")));var d=function(){return null!=i};e.is_supported=d;var v=function(){return u};e.is_muted=v;var h=function(t){return u=t};e.mute=h},"357c":function(t,e,n){"use strict";n.r(e);var r=n("9d62"),a=n("0130");for(var i in a)"default"!==i&&function(t){n.d(e,t,function(){return a[t]})}(i);n("1f3d");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"d0d4a5e0",null);u.options.__file="Disc.vue",e["default"]=u.exports},"37c1":function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"box"},t._l(t.rows,function(e){return n("div",{staticClass:"row"},t._l(e,function(e){var r=e.disc,a=e.can_move,i=e.is_hover,o=e.will_flip,u=e.move,s=e.enter,c=e.leave;return n("div",{staticClass:"cell",on:{mouseenter:s,mouseleave:c,click:u}},[r?n("transition",{attrs:{name:"flip",mode:"out-in",appear:""}},[n("Disc",{key:r,staticClass:"disc",attrs:{color:r,will_flip:o}})],1):t._e(),t.guide&&a&&!t.hover_at?n("div",{staticClass:"move"}):t._e(),i?n("Disc",{staticClass:"hover",attrs:{color:t.turn==t.BLACK?"black":"white"}}):t._e()],1)}),0)}),0)},a=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return a})},"3dfd":function(t,e,n){"use strict";var r=n("55b3"),a=n("6593"),i=(n("7faf"),n("2877")),o=Object(i["a"])(a["default"],r["a"],r["b"],!1,null,null,null);o.options.__file="App.vue",e["default"]=o.exports},"3e51":function(t,e,n){"use strict";var r=n("03cd"),a=n.n(r);a.a},"3f21":function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"box"},[n("div",{staticClass:"colors"},[n("div",{staticClass:"color select",class:t.color==t.BLACK&&"is-active",on:{click:function(e){t.color=t.BLACK}}},[n("Disc",{attrs:{color:"black"}}),n("span",[t._v(t._s(t.i18n.first_move))])],1),n("div",{staticClass:"color select",class:t.color==t.WHITE&&"is-active",on:{click:function(e){t.color=t.WHITE}}},[n("Disc",{attrs:{color:"white"}}),n("span",[t._v(t._s(t.i18n.second_move))])],1)]),n("div",{staticClass:"levels"},t._l(t.levels,function(e){return n("div",{staticClass:"level select",class:t.level==e.toLowerCase()&&"is-active",on:{click:function(n){t.level=e.toLowerCase()}}},[t._v(t._s(t.i18n[e]))])}),0),n("div",{staticClass:"guide select",on:{click:function(e){t.guide=!t.guide}}},[t.guide?n("CheckboxMarked"):t._e(),t.guide?t._e():n("CheckboxBlankOutline"),n("span",{staticClass:"label"},[t._v(t._s(t.i18n.show_guide))])],1),n("div",{staticClass:"langs"},[n("a",{staticClass:"lang select",class:"en"==t.i18n.lang&&"is-active",attrs:{href:"?lang=en"}},[t._v("English")]),n("a",{staticClass:"lang select",class:"ja"==t.i18n.lang&&"is-active",attrs:{href:"?lang=ja"}},[t._v("日本語")])]),n("Button",{on:{click:t.submit}},[t._v(t._s(t.i18n.start))])],1)},a=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return a})},"48e5":function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"screen"},[n("header",[n("div",{staticClass:"icons"},[n("Button",{attrs:{border:!1},on:{click:t.back}},[n("BackIcon")],1),t.sound_supported?n("Button",{attrs:{border:!1},on:{click:t.mute}},[t.muted?t._e():n("SoundIcon"),t.muted?n("MuteIcon"):t._e()],1):t._e()],1),n("div",{staticClass:"level"},[t._v(t._s(t.level_title))]),n("Button",{staticClass:"undo",attrs:{disabled:!t.undo_enabled},on:{click:t.undo}},[t._v(t._s(t.i18n.undo))])],1),n("main",[n("Board",{staticClass:"board",attrs:{user:t.user,level:t.level,guide:t.guide,message:t.show_message,back:t.back,set_undo_btn:t.set_undo_btn}}),n("div",{staticClass:"msg-box-wrapper"},[n("transition",{attrs:{name:"msg"}},[t.msg?n("MessageBox",t._b({key:t.msg_key,staticClass:"msg-box"},"MessageBox",t.msg,!1)):t._e()],1)],1)],1)])},a=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return a})},"521f":function(t,e,n){"use strict";n.r(e);var r=n("92af"),a=n("b823");for(var i in a)"default"!==i&&function(t){n.d(e,t,function(){return a[t]})}(i);n("f0fa");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"fe2898a0",null);u.options.__file="MessageBox.vue",e["default"]=u.exports},"55b3":function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{attrs:{id:"app"}},["setting"==t.mode?n("h1",[t._v("UCTOTH")]):t._e(),"setting"==t.mode?n("Setting",{attrs:{start:t.start}}):t._e(),"game"==t.mode?n("Game",{attrs:{user:t.color,level:t.level,guide:t.guide,back:t.back}}):t._e(),t._m(0)],1)},a=[function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"link"},[n("a",{attrs:{href:"https://github.com/ts1/uctoth",target:"_blank"}},[t._v("Source code")])])}];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return a})},"56d7":function(t,e,n){"use strict";n.r(e);n("cadf"),n("551c"),n("097d");var r=n("2b0e"),a=n("3dfd");r["a"].config.productionTip=!1,new r["a"]({render:function(t){return t(a["default"])}}).$mount("#app")},"5d48":function(t,e,n){"use strict";var r=n("a460"),a=n.n(r);a.a},6593:function(t,e,n){"use strict";var r=n("2a90"),a=n.n(r);e["default"]=a.a},"7d37":function(t,e,n){"use strict";var r=n("9ed8"),a=n.n(r);a.a},"7faf":function(t,e,n){"use strict";var r=n("8fba"),a=n.n(r);a.a},"85a1":function(t,e,n){"use strict";var r=n("4ea4");Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0;var a=r(n("3835"));n("ac6a"),n("cadf"),n("551c"),n("097d");var i,o=n("fb4e"),u=r(n("357c")),s=r(n("e5a2")),c=r(n("f4a7")),l=r(n("2ba8"));i=new s.default;var f={props:["user","level","guide","message","back","set_undo_btn"],data:function(){return{board:new o.Board,turn:o.BLACK,flips:[],hover_at:null,undo_stack:[],thinking:!1,user_moves:0,gameover:!1,will_flip_enabled:!1,BLACK:o.BLACK,i18n:c.default}},mounted:function(){return i.postMessage({type:"set_level",level:this.level}),this.turn===this.user?this.message({text:this.i18n.your_turn}):this.worker_move(),gtag("event","start",{event_category:"game",event_label:this.level})},updated:function(){return this.$el.classList.add("animate")},computed:{can_undo:function(){return!this.thinking&&this.user_moves&&!this.gameover},rows:function(){var t,e,n,r=this;return e=function(){var e,r,a=this;for(r=[],n=e=0;e<8;n=++e)t=[],[0,1,2,3,4,5,6,7].forEach(function(e){var r,i;return i=(0,o.pos_from_xy)(e,n),r=a.board.get(i),t.push({disc:r===o.BLACK?"black":r===o.WHITE?"white":null,can_move:a.turn===a.user&&a.board.can_move(a.turn,i),is_hover:a.turn===a.user&&(a.hover_at===i&&a.board.can_move(a.turn,i)),will_flip:a.will_flip_enabled&&a.flips.indexOf(i)>=0,move:function(){if(a.turn===a.user)return a.move(i)},enter:function(){if(a.turn===a.user)return a.flips=a.board.move(a.turn,i),a.flips.length&&(a.board.undo(a.turn,i,a.flips),a.hover_at=i),a.will_flip_enabled=!1},leave:function(){return a.hover_at=null,a.flips=[],a.will_flip_enabled=!1}})}),r.push(t);return r}.call(this),setTimeout(function(){return r.will_flip_enabled=!0},50),e}},methods:{move:function(t){var e,n,r,a=this;if(this.flips=[],this.hover_at=null,n=this.board.move(this.turn,t),n.length)return(0,l.default)("move"),this.undo_stack.push([this.turn,t,n]),this.turn===this.user&&this.user_moves++,this.turn=-this.turn,this.board.any_moves(this.turn)?this.turn===this.user?this.message({text:this.i18n.your_turn}):this.worker_move():(this.turn=-this.turn,this.board.any_moves(this.turn)?this.turn===this.user?this.message({text:this.i18n.i_pass}):this.message({text:this.i18n.you_pass,pass:function(){return a.worker_move()}}):(this.gameover=!0,r=this.board.outcome(this.user),e="".concat(this.board.count(this.user),":").concat(this.board.count(-this.user)),r>0?(this.message({text:c.default.expand("win",{discs:e}),back:this.back}),gtag("event","win",{event_category:"game",event_label:this.level,value:r})):r<0?(this.message({text:c.default.expand("lose",{discs:e}),back:this.back}),gtag("event","lose",{event_category:"game",event_label:this.level,value:r})):(this.message({text:this.i18n.draw,back:this.back}),gtag("event","draw",{event_category:"game",event_label:this.level,value:r}))))},worker_move:function(){var t,e=this;return this.message({text:this.i18n.thinking,spin:!0}),t=Date.now(),i.onmessage=function(n){var r,a;i.onmessage=null,t=Date.now()-t,console.log("".concat(t," msec"));var o=n.data;return r=o.move,a=o.value,null!=a&&console.log("Estimated value",Math.round(100*a)/100),setTimeout(function(){return e.move(r),e.thinking=!1},t<2e3?2e3-t:0)},this.thinking=!0,i.postMessage({type:"move",board:this.board.dump(),turn:this.turn})},undo:function(){var t,e,n;if(!this.can_undo)throw new Error("cannot undo");while(1){var r=this.undo_stack.pop(),i=(0,a.default)(r,3);if(n=i[0],e=i[1],t=i[2],this.board.undo(n,e,t),n===this.user)break}return this.user_moves--,this.board.board.push(0),this.board.board.pop()}},watch:{can_undo:function(){return this.set_undo_btn(this.can_undo,this.undo)}},components:{Disc:u.default}};e.default=f},"89a8":function(t,e,n){"use strict";n.r(e);var r=n("94ff"),a=n.n(r);for(var i in r)"default"!==i&&function(t){n.d(e,t,function(){return r[t]})}(i);e["default"]=a.a},"89c4":function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("097d");var r={props:["color","will_flip"]};e.default=r},"8fba":function(t,e,n){},"91ea":function(t,e,n){"use strict";n.r(e);var r=n("37c1"),a=n("f0a0");for(var i in a)"default"!==i&&function(t){n.d(e,t,function(){return a[t]})}(i);n("9aa9");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"46699115",null);u.options.__file="Board.vue",e["default"]=u.exports},"929d":function(t,e,n){},"92af":function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"box"},[n("div",{staticClass:"text"},[t.spin?n("Spinner",{staticClass:"spinner"}):t._e(),t._v(t._s(t.text))],1),t.pass||t.back?n("div",{staticClass:"action"},[t.pass?n("Button",{attrs:{theme:"light"},on:{click:t.pass}},[t._v(t._s(t.i18n.pass))]):t._e(),t.back?n("Button",{attrs:{theme:"light"},on:{click:t.back}},[t._v(t._s(t.i18n.play_again))]):t._e()],1):t._e()])},a=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return a})},"94ff":function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("097d");var r={props:["theme","border"],computed:{className:function(){var t;return[this.theme||"dark",null==(t=this.border)||t?"border":null]}}};e.default=r},"9aa9":function(t,e,n){"use strict";var r=n("a7a6"),a=n.n(r);a.a},"9d62":function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("svg",{class:[t.will_flip&&"flip",t.color],attrs:{viewBox:"0 0 100 100"}},[n("circle",{attrs:{cx:"50",cy:"50",r:"50"}})])},a=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return a})},"9d6c":function(t,e,n){"use strict";var r=n("4ea4");Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("097d");var a=r(n("2375")),i=r(n("2a7d")),o=r(n("f4a7")),u={props:["text","pass","back","spin"],data:function(){return{i18n:o.default}},components:{Spinner:a.default,Button:i.default}};e.default=u},"9ed8":function(t,e,n){},a460:function(t,e,n){},a7a6:function(t,e,n){},b823:function(t,e,n){"use strict";n.r(e);var r=n("9d6c"),a=n.n(r);for(var i in r)"default"!==i&&function(t){n.d(e,t,function(){return r[t]})}(i);e["default"]=a.a},bc83:function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("button",{class:t.className,on:{click:function(e){t.$emit("click")}}},[t._t("default")],2)},a=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return a})},bdd9:function(t,e,n){"use strict";var r=n("929d"),a=n.n(r);a.a},be17:function(t,e,n){"use strict";var r=n("4ea4");Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("097d");var a=n("fb4e"),i=r(n("357c"));n("d48d");var o,u,s=r(n("576b")),c=r(n("8ca1")),l=r(n("2a7d")),f=r(n("f4a7"));u=function(t,e){return localStorage["_oth_"+t]=JSON.stringify(e)},o=function(t,e){var n;return n=localStorage["_oth_"+t],null!=n?JSON.parse(n):e};var d={props:["start"],data:function(){return{levels:["easiest","easy","normal","hard","hardest"],color:o("color",a.BLACK),level:o("level","normal"),guide:o("guide",!0),BLACK:a.BLACK,WHITE:a.WHITE,i18n:f.default}},methods:{submit:function(){return u("color",this.color),u("level",this.level),u("guide",this.guide),this.start(this.color,this.level,this.guide)}},components:{Disc:i.default,CheckboxMarked:s.default,CheckboxBlankOutline:c.default,Button:l.default}};e.default=d},cff9:function(t,e){t.exports="data:audio/mpeg;base64,SUQzBAAAAAAAI1RTU0UAAAAPAAADTGF2ZjU3LjgzLjEwMAAAAAAAAAAAAAAA//tAwAAAAAAAAAAAAAAAAAAAAAAASW5mbwAAAA8AAAADAAADKAB7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3u9vb29vb29vb29vb29vb29vb29vb29vb29vb29vb29vb3///////////////////////////////////////////8AAAAATGF2YzU3LjEwAAAAAAAAAAAAAAAAJAKjAAAAAAAAAyjcTOkNAAAAAAD/+1DEAAAKWKc4NPeAEXkXrvcekAIBPe79/fCcIIEfBziZpckACQAAANA7QBwA4GIb49Y9Z1vjkE3FzLm5tiGIY4MZOC4KCJm8e/vf//+l77xR5EpmlKUp//////R/HPiAMCQ5wQ/4YkiSIIKSUSabbjkkEAAlJ/kR3C6c1fEFmnIE5oefSOjIkxANohUSoFJClQuZvCGJJAm9Um16Pw37DYOSuG7DIR3Nt7t2o+tvEEveW34y93S1ocGnjS8g0FhZSW/1lBa7RIkJNdVnsdw7//tSxAUAC3SZY5zzADFwlWc09g4ZjHQrZ8pGM2EmgQCVHFHkkiCoonJnSWzJHJUclm6jkS2tRVEt/3lohktR0ureWn5+2opZFJ5igMHbip4yLhRpgGgZOjXSI92teCoaKgr2hMjVeLYAAAAAQ3QP6IUhpwXMQmIDsAZBDwiRzmwZwNcGzCH0ax+myckjUDZS4cPGJiWWjI5MXfhd77FxjbnHUMaxiPjHPil7HPdQQE9j5ddyEtouut43vjAXibf/yFbFgAAAAJN38eyZRA3iVDj/+1LEBwGLGKslJ6RywS0Kocg3mHgHeUQcwR1GE2SASYhAYpeSUukaZpSgVJpslZcTLgZQpmXkohZQoVp1S07ONRqxmPKRxm84pcFGv5qCFiQVSEnnT1f+n/6tmv///6RZq4ZmbTlUAKYbAaRIS8m8cRdTFCHF0GMwsKhRTnMWloKicSPCQYpPJhINFioCBkBERKIgdMLAXvypH39KxlPliv/1bMl//yJXS2lMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVQ=="},e2ec:function(t,e,n){"use strict";n.r(e);var r=n("eaf8"),a=n.n(r);for(var i in r)"default"!==i&&function(t){n.d(e,t,function(){return r[t]})}(i);e["default"]=a.a},e5a2:function(t,e,n){t.exports=function(){return new Worker(n.p+"js/worker.63e309a1fd2f553c5fb7.js")}},eaf8:function(t,e,n){"use strict";var r=n("dbce"),a=n("4ea4");Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("097d");var i=a(n("99b8")),o=a(n("c068")),u=a(n("4d77")),s=a(n("91ea")),c=a(n("521f")),l=a(n("2a7d")),f=a(n("f4a7")),d=r(n("2ba8")),v={props:["user","level","guide","back"],data:function(){return{msg:null,msg_key:0,undo_enabled:!1,undo:function(){},muted:d.is_muted(),sound_supported:d.is_supported(),i18n:f.default}},mounted:function(){return window.scrollTo(0,0)},computed:{level_title:function(){var t;return t=f.default[this.level],f.default.expand("mode",{mode:t})}},methods:{show_message:function(t){return this.msg_key++,this.msg=t},set_undo_btn:function(t,e){return this.undo_enabled=t,this.undo=e},mute:function(){return this.muted=!this.muted,d.mute(this.muted)}},components:{BackIcon:i.default,SoundIcon:o.default,MuteIcon:u.default,Board:s.default,MessageBox:c.default,Button:l.default}};e.default=v},f0a0:function(t,e,n){"use strict";n.r(e);var r=n("85a1"),a=n.n(r);for(var i in r)"default"!==i&&function(t){n.d(e,t,function(){return r[t]})}(i);e["default"]=a.a},f0fa:function(t,e,n){"use strict";var r=n("03a8"),a=n.n(r);a.a},f346:function(t,e,n){"use strict";(function(e){var r=n("4ea4");n("aef6"),n("551c"),n("ac6a"),n("5df3"),n("f400"),n("cadf");var a,i,o,u,s,c,l,f,d=r(n("2909"));n("097d"),f=function(t){var e,n,r,a,i;for(t=(0,d.default)(t),r=t.length,e=n=r-1;n>0;e=n+=-1)a=Math.random()*(e+1)|0,i=t[e],t[e]=t[a],t[a]=i;return t},s=function(t){var e;return e=new Map,function(){for(var n,r=arguments.length,a=new Array(r),i=0;i<r;i++)a[i]=arguments[i];return n=e.get(a),void 0===n&&(n=t.apply(void 0,a),e.set(a)),n}},o=function(t){return 0|t},c=function(t,r){return new Promise(function(a){var i,o;return"-"===t?o=e.stdin:(o=n("3e8f").createReadStream(t),t.endsWith(".gz")&&(o=o.pipe(n("3e8f").createGunzip()))),i=n("3e8f").createInterface(o),i.on("line",function(t){return r(t)}),i.on("close",function(){return a()})})},i=function(t){var r,a;return"-"===t?e.stdout:(a=n("3e8f").createWriteStream(t),t.endsWith(".gz")?(r=n("3e8f").createGzip(),r.pipe(a),r):a)},u=function(t){var e,n,r,a,i,o,u,s;return e={},r={},r.prev=r.next=r,u=0,a=0,o=0,n=0,s=function(t){return t.next.prev=t.prev,t.prev.next=t.next},i=function(t){return t.prev=r,t.next=r.next,r.next.prev=t,r.next=t},{put:function(a,o){var c,l;return c=e[a],c?s(c):u>=t?(n+=1,l=r.prev,s(l),delete e[l.key]):u++,c={key:a,data:o},i(c),e[a]=c},get:function(t){var n;return n=e[t],n?(a+=1,n!==r.next&&(s(n),i(n)),n.data):(o+=1,null)},stats:function(){return{n:u,hit:a,miss:o,evict:n}}}},l=function(t){return Math.round(1e4*t)/1e4},a=1<<30,t.exports={shuffle:f,memoize:s,int:o,readlines:c,gzwriter:i,lru_cache:u,round_value:l,INFINITY:a}}).call(this,n("4362"))},f4a7:function(t,e,n){"use strict";var r=n("4ea4");n("a481"),n("7f7f");var a,i,o,u,s,c,l,f=r(n("3835"));n("28a5"),n("386d"),n("cadf"),n("551c"),n("097d"),l={en:{first_move:"First move",second_move:"Second move",show_guide:"Show guide",start:"Start",undo:"Undo",your_turn:"Your turn.",thinking:"Thinking...",you_pass:"You have no moves.",pass:"Pass",i_pass:"I have no moves. Your turn.",win:"You won by ${discs}!",lose:"You lost by ${discs}!",draw:"Draw!",play_again:"Play Again",easiest:"Easiest",easy:"Easy",normal:"Normal",hard:"Hard",hardest:"Hardest",mode:"${mode} mode"},ja:{first_move:"先手",second_move:"後手",show_guide:"ガイドを表示する",start:"スタート",undo:"待った",your_turn:"あなたの番です。",thinking:"考えています...",you_pass:"あなたの打てるところがありません。",pass:"パス",i_pass:"私の打てるところがありません。あなたの番です。",win:"${discs}であなたの勝ちです!",lose:"${discs}であなたの負けです!",draw:"引き分け!",play_again:"もう一度プレイする",easiest:"超イージー",easy:"イージー",normal:"ノーマル",hard:"ハード",hardest:"超ハード",mode:"${mode}モード",description:"UctothはWebブラウザで遊べるシンプルなオセロ(リバーシ)ゲームです。"}},u=function(){var t,e,n,r,a,i,o,u=arguments.length>0&&void 0!==arguments[0]?arguments[0]:window.location.search;for("?"===u[0]&&(u=u.substr(1)),i={},a=u.split("&"),t=0,r=a.length;t<r;t++){n=a[t];var s=n.split("="),c=(0,f.default)(s,2);e=c[0],o=c[1],e=decodeURIComponent(e),o=decodeURIComponent(o),i[e]=o}return i},o=u(),i=o.lang,i?localStorage._oth_lang=o.lang:i=localStorage._oth_lang||(null!=(s=window.navigator.languages)?s[0]:void 0)||window.navigator.language||window.navigator.userLanguage||window.navigator.browserLanguage,l[i]||(i="en"),c=l[i],"en"!==i&&(document.querySelector("html").setAttribute("lang",i),document.querySelector('meta[name="description"]').setAttribute("content",c.description)),a=function(t,e){var n;if(n=c[t],!n)throw new Error("no translation");return n.replace(/\$\{(\w+)\}/g,function(t,n){return e[n]})},t.exports=c,t.exports.lang=i,t.exports.expand=a},f571:function(t,e,n){"use strict";n.r(e);var r=n("be17"),a=n.n(r);for(var i in r)"default"!==i&&function(t){n.d(e,t,function(){return r[t]})}(i);e["default"]=a.a},fb4e:function(t,e,n){"use strict";var r=n("4ea4");n("28a5");var a,i,o,u,s,c,l,f,d,v,h,p,_,m,b,g,A,y,w,k,x,C,S=r(n("2909")),E=r(n("d4ec")),B=r(n("bee2"));n("ac6a"),n("5df3"),n("f400"),n("cadf"),n("551c"),n("097d");var j=n("f346");b=j.int,c=0,o=1,h=-1,l=2,w=function(t,e){return 9*(e+1)+(t+1)},y=function(t){var e,n;if(e=t.toLowerCase().charCodeAt(0)-"a".charCodeAt(0),n=parseInt(t[1])-1,e<0||e>7||n<0||n>7)throw new Error("invalid position string");return w(e,n)},x=function(t){return{x:t%9-1,y:b(t/9)-1}},k=function(t){var e,n,r,a=arguments.length>1&&void 0!==arguments[1]?arguments[1]:o,i=x(t);return n=i.x,r=i.y,e=a===o?"A":"a",String.fromCharCode(e.charCodeAt(0)+n)+(r+1)},g=function(t){var e,n,r;n=/([a-hA-H][1-8])/g,r=[];while(1){if(e=n.exec(t),!e)break;r.push(y(e[0]))}return r},A=function(t){var e,n;return n=function(){var n,r,a;for(a=[],n=0,r=t.length;n<r;n++)e=t[n],null!=e.move&&null!=e.turn?a.push(k(e.move,e.turn)):a.push(k(e));return a}(),n.join("")},_={"-":c,X:o,O:h},m=function(t){return _[t]},C=function(){var t,e,n;return e=new Map(function(){var e;for(t in e=[],_)n=_[t],e.push([n,t]);return e}()),function(t){return e.get(t)||"?"}}(),i=function(){var t,e,n,r,a;for(n=[],a=t=0;t<=7;a=++t)for(r=e=0;e<=7;r=++e)n.push(w(r,a));return n}(),p=[],p[y("B2")]=!0,p[y("G2")]=!0,p[y("B7")]=!0,p[y("G7")]=!0,v=-9,s=9,f=-1,d=1,a=[v+f,v,v+d,f,d,s+f,s,s+d],function(){var t,e,n,r,a,i,o,u;for(t=["A1","C1","A3","D1","A4","C3","D3","C4","D2","B4","B1","A2","C2","B3","B2","D4"],r=[],e=0,n=t.length;e<n;e++){i=t[e],a=y(i);var s=x(a);o=s.x,u=s.y,r.push(w(o,u)),r.push(w(7-o,u)),r.push(w(o,7-u)),r.push(w(7-o,7-u))}}(),u=function(){function t(e){(0,E.default)(this,t),e?"string"===typeof e?this.load(e):(this.board=(0,S.default)(e.board),this.build_empty_list()):this.load("- - - - - - - -\n- - - - - - - -\n- - - - - - - -\n- - - O X - - -\n- - - X O - - -\n- - - - - - - -\n- - - - - - - -\n- - - - - - - -")}return(0,B.default)(t,[{key:"load",value:function(t){var e,n,r,a,i,o,u,s,f;for(e=l,r=c,this.board=[e,e,e,e,e,e,e,e,e,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,e,e,e,e,e,e,e,e,e],s=0,f=0,o=t.split(""),a=0,i=o.length;a<i;a++)if(n=o[a],u=m(n),"undefined"!==typeof u){if(f>=8)throw new Error("too many cells");this.board[w(s,f)]=u,++s>=8&&(s=0,f++)}if(f<8)throw new Error("too few cells");return this.build_empty_list()}},{key:"dump",value:function(){var t,e,n,r,a,i,o,u=arguments.length>0&&void 0!==arguments[0]&&arguments[0];if(r=[],u){for(r.push(" "),i=t=0;t<=7;i=++t)r.push(" "),r.push(String.fromCharCode("A".charCodeAt(0)+i));r.push("\n")}for(o=e=0;e<=7;o=++e){for(u&&(r.push(o+1),r.push(" ")),i=n=0;n<=7;i=++n)r.push(C(this.board[w(i,o)])||"?"),u&&r.push(" ");u&&r.push(o+1),u&&r.push("\n")}if(u)for(r.push(" "),i=a=0;a<=7;i=++a)r.push(" "),r.push(String.fromCharCode("A".charCodeAt(0)+i));return r.join("")}},{key:"get",value:function(t){return this.board[t]}},{key:"count",value:function(t){var e,n=this;return e=0,i.forEach(function(r){if(n.board[r]===t)return e++}),e}},{key:"can_move",value:function(t,e){var n,r,i,o,u;if(this.board[e]===c)for(r=-t,i=0,o=a.length;i<o;i++)if(n=a[i],u=e+n,this.board[u]===r){u+=n;while(this.board[u]===r)u+=n;if(this.board[u]===t)return!0}return!1}},{key:"any_moves",value:function(t){var e,n=this;return e=!1,this.each_empty(function(r){if(n.can_move(t,r))return e=!0,!1}),e}},{key:"count_moves",value:function(t){var e,n=this;return e=0,this.each_empty(function(r){if(n.can_move(t,r))return e++}),e}},{key:"list_moves",value:function(t){var e,n=this;return e=[],this.each_empty(function(r){if(n.can_move(t,r))return e.push(r)}),e}},{key:"list_moves_but_x",value:function(t){var e,n=this;return e=[],this.each_empty(function(r){if(!p[r]&&n.can_move(t,r))return e.push(r)}),e}},{key:"move",value:function(t,e){var n,r,i,o,u,s,l=!(arguments.length>2&&void 0!==arguments[2])||arguments[2];if(r=[],this.board[e]===c){for(i=-t,o=0,u=a.length;o<u;o++)if(n=a[o],s=e+n,this.board[s]===i){s+=n;while(this.board[s]===i)s+=n;if(this.board[s]===t)while((s-=n)!==e)this.board[s]=t,r.push(s)}r.length&&(this.board[e]=t,l&&this.pop_empty_list(e))}return r}},{key:"count_flips",value:function(t,e){var n,r,i,o,u,s,l;if(r=0,this.board[e]===c)for(i=-t,o=0,u=a.length;o<u;o++){n=a[o],l=e+n,s=0;while(this.board[l]===i)l+=n,s++;this.board[l]===t&&(r+=s)}return r}},{key:"undo",value:function(t,e,n){var r,a,i,o,u=!(arguments.length>3&&void 0!==arguments[3])||arguments[3];for(r=-t,a=0,i=n.length;a<i;a++)o=n[a],this.board[o]=r;if(this.board[e]=c,u)return this.push_empty_list(e)}},{key:"score",value:function(t){var e,n,r=this;return e=-t,n=0,i.forEach(function(a){switch(r.board[a]){case t:return n++;case e:return n--}}),n}},{key:"outcome",value:function(){var t,e,n,r=this,a=arguments.length>0&&void 0!==arguments[0]?arguments[0]:o;return e=-a,n=0,t=0,i.forEach(function(i){switch(r.board[i]){case a:return n++;case e:return n--;case c:return t++}}),t&&(n>0?n+=t:n<0&&(n-=t)),n}},{key:"build_empty_list",value:function(){var t,e=this;return this.empty_next=[0],this.empty_prev=[0],t=0,i.forEach(function(n){if(e.board[n]===c)return e.empty_next[t]=n,e.empty_prev[n]=t,t=n}),this.empty_next[t]=0}},{key:"pop_empty_list",value:function(t){return this.empty_next[this.empty_prev[t]]=this.empty_next[t],this.empty_prev[this.empty_next[t]]=this.empty_prev[t]}},{key:"push_empty_list",value:function(t){return this.empty_next[this.empty_prev[t]]=t,this.empty_prev[this.empty_next[t]]=t}},{key:"first_empty",value:function(){return this.empty_next[0]}},{key:"each_empty",value:function(t){var e,n;e=0,n=[];while(1){if(e=this.empty_next[e],0===e)break;if(!1===t(e))break;n.push(void 0)}return n}},{key:"validate_empty_list",value:function(){var t,e,n=this;return e=0,this.each_empty(function(t){return console.assert(n.board[t]===c),e++}),t=0,i.forEach(function(e){if(n.board[e]===c)return t++}),console.assert(e===t)}}]),t}(),t.exports={EMPTY:c,BLACK:o,WHITE:h,GUARD:l,ALL_POSITIONS:i,UP:v,DOWN:s,LEFT:f,RIGHT:d,pos_from_xy:w,pos_from_str:y,pos_to_xy:x,pos_to_str:k,pos_array_from_str:g,pos_array_to_str:A,square_to_char:C,char_to_square:m,Board:u}}});
//# sourceMappingURL=app.1a7d038e.js.map