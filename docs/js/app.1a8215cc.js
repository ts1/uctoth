(function(e){function t(t){for(var r,o,u=t[0],s=t[1],c=t[2],f=0,d=[];f<u.length;f++)o=u[f],a[o]&&d.push(a[o][0]),a[o]=0;for(r in s)Object.prototype.hasOwnProperty.call(s,r)&&(e[r]=s[r]);l&&l(t);while(d.length)d.shift()();return i.push.apply(i,c||[]),n()}function n(){for(var e,t=0;t<i.length;t++){for(var n=i[t],r=!0,u=1;u<n.length;u++){var s=n[u];0!==a[s]&&(r=!1)}r&&(i.splice(t--,1),e=o(o.s=n[0]))}return e}var r={},a={app:0},i=[];function o(t){if(r[t])return r[t].exports;var n=r[t]={i:t,l:!1,exports:{}};return e[t].call(n.exports,n,n.exports,o),n.l=!0,n.exports}o.m=e,o.c=r,o.d=function(e,t,n){o.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n})},o.r=function(e){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},o.t=function(e,t){if(1&t&&(e=o(e)),8&t)return e;if(4&t&&"object"===typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(o.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var r in e)o.d(n,r,function(t){return e[t]}.bind(null,r));return n},o.n=function(e){var t=e&&e.__esModule?function(){return e["default"]}:function(){return e};return o.d(t,"a",t),t},o.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},o.p="/uctoth/";var u=window["webpackJsonp"]=window["webpackJsonp"]||[],s=u.push.bind(u);u.push=t,u=u.slice();for(var c=0;c<u.length;c++)t(u[c]);var l=s;i.push([0,"chunk-vendors"]),n()})({0:function(e,t,n){e.exports=n("56d7")},"00a7":function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"box"},e._l(e.rows,function(t){return n("div",{staticClass:"row"},e._l(t,function(t){var r=t.disc,a=t.can_move,i=t.is_hover,o=t.will_flip,u=t.move,s=t.enter,c=t.leave;return n("div",{staticClass:"cell",on:{mouseenter:s,mouseleave:c,click:u}},[r?n("transition",{attrs:{name:"flip",mode:"out-in",appear:""}},[n("Disc",{key:r,staticClass:"disc",attrs:{color:r,will_flip:o}})],1):e._e(),e.guide&&a&&!e.hover_at?n("div",{staticClass:"move"}):e._e(),i?n("Disc",{staticClass:"hover",attrs:{color:e.turn==e.BLACK?"black":"white"}}):e._e()],1)}),0)}),0)},a=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return a})},"0130":function(e,t,n){"use strict";n.r(t);var r=n("89c4"),a=n.n(r);for(var i in r)"default"!==i&&function(e){n.d(t,e,function(){return r[e]})}(i);t["default"]=a.a},"03a8":function(e,t,n){},"03cd":function(e,t,n){},1048:function(e,t,n){},"148a":function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{attrs:{id:"app"}},["setting"==e.mode?n("Setting",{attrs:{start:e.start}}):e._e(),"game"==e.mode?n("Game",{attrs:{user:e.color,level:e.level,guide:e.guide,back:e.back}}):e._e()],1)},a=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return a})},"1f3d":function(e,t,n){"use strict";var r=n("1048"),a=n.n(r);a.a},2375:function(e,t,n){"use strict";n.r(t);var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("svg",{staticClass:"spinner",attrs:{viewBox:"0 0 100 100"}},[n("circle",{attrs:{cx:"50",cy:"50",fill:"none",stroke:"currentColor","stroke-width":"7",r:"35","stroke-dasharray":"200 20"}})])},a=[],i=(n("3e51"),n("2877")),o={},u=Object(i["a"])(o,r,a,!1,null,"2aca0085",null);u.options.__file="Spinner.vue";t["default"]=u.exports},"25e0":function(e,t,n){"use strict";n.r(t);var r=n("ca1a"),a=n("e2ec");for(var i in a)"default"!==i&&function(e){n.d(t,e,function(){return a[e]})}(i);n("686a");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"48141794",null);u.options.__file="Game.vue",t["default"]=u.exports},"27c5":function(e,t,n){"use strict";n.r(t);var r=n("3f21"),a=n("f571");for(var i in a)"default"!==i&&function(e){n.d(t,e,function(){return a[e]})}(i);n("5d48");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"6a8b899b",null);u.options.__file="Setting.vue",t["default"]=u.exports},"2a7d":function(e,t,n){"use strict";n.r(t);var r=n("bc83"),a=n("89a8");for(var i in a)"default"!==i&&function(e){n.d(t,e,function(){return a[e]})}(i);n("7d37");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"4ba721ed",null);u.options.__file="Button.vue",t["default"]=u.exports},"2a90":function(e,t,n){"use strict";var r=n("4ea4");Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("097d"),n("494d");var a=r(n("27c5")),i=r(n("25e0")),o={name:"app",data:function(){return{mode:"setting",color:null,level:null,guide:null}},methods:{start:function(e,t,n){return this.color=e,this.level=t,this.guide=n,this.mode="game"},back:function(){return this.mode="setting"}},components:{Setting:a.default,Game:i.default}};t.default=o},"357c":function(e,t,n){"use strict";n.r(t);var r=n("9d62"),a=n("0130");for(var i in a)"default"!==i&&function(e){n.d(t,e,function(){return a[e]})}(i);n("1f3d");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"d0d4a5e0",null);u.options.__file="Disc.vue",t["default"]=u.exports},"3dfd":function(e,t,n){"use strict";var r=n("148a"),a=n("6593"),i=(n("7faf"),n("2877")),o=Object(i["a"])(a["default"],r["a"],r["b"],!1,null,null,null);o.options.__file="App.vue",t["default"]=o.exports},"3e51":function(e,t,n){"use strict";var r=n("03cd"),a=n.n(r);a.a},"3f21":function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"box"},[n("div",{staticClass:"colors"},[n("div",{staticClass:"color select",class:e.color==e.BLACK&&"is-active",on:{click:function(t){e.color=e.BLACK}}},[n("Disc",{attrs:{color:"black"}}),n("span",[e._v(e._s(e.i18n.first_move))])],1),n("div",{staticClass:"color select",class:e.color==e.WHITE&&"is-active",on:{click:function(t){e.color=e.WHITE}}},[n("Disc",{attrs:{color:"white"}}),n("span",[e._v(e._s(e.i18n.second_move))])],1)]),n("div",{staticClass:"levels"},e._l(e.levels,function(t){return n("div",{staticClass:"level select",class:e.level==t.toLowerCase()&&"is-active",on:{click:function(n){e.level=t.toLowerCase()}}},[e._v(e._s(e.i18n[t]))])}),0),n("div",{staticClass:"guide select",on:{click:function(t){e.guide=!e.guide}}},[e.guide?n("CheckboxMarked"):e._e(),e.guide?e._e():n("CheckboxBlankOutline"),n("span",{staticClass:"label"},[e._v(e._s(e.i18n.show_guide))])],1),n("div",{staticClass:"langs"},[n("a",{staticClass:"lang select",class:"en"==e.i18n.lang&&"is-active",attrs:{href:"?lang=en"}},[e._v("English")]),n("a",{staticClass:"lang select",class:"ja"==e.i18n.lang&&"is-active",attrs:{href:"?lang=ja"}},[e._v("日本語")])]),n("Button",{on:{click:e.submit}},[e._v(e._s(e.i18n.start))])],1)},a=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return a})},"521f":function(e,t,n){"use strict";n.r(t);var r=n("92af"),a=n("b823");for(var i in a)"default"!==i&&function(e){n.d(t,e,function(){return a[e]})}(i);n("f0fa");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"fe2898a0",null);u.options.__file="MessageBox.vue",t["default"]=u.exports},"56d7":function(e,t,n){"use strict";n.r(t);n("cadf"),n("551c"),n("097d");var r=n("2b0e"),a=n("3dfd");r["a"].config.productionTip=!1,new r["a"]({render:function(e){return e(a["default"])}}).$mount("#app")},"5d48":function(e,t,n){"use strict";var r=n("a460"),a=n.n(r);a.a},6593:function(e,t,n){"use strict";var r=n("2a90"),a=n.n(r);t["default"]=a.a},"686a":function(e,t,n){"use strict";var r=n("cff4"),a=n.n(r);a.a},"7d37":function(e,t,n){"use strict";var r=n("9ed8"),a=n.n(r);a.a},"7faf":function(e,t,n){"use strict";var r=n("8fba"),a=n.n(r);a.a},"85a1":function(module,exports,__webpack_require__){"use strict";var _interopRequireDefault=__webpack_require__("4ea4");Object.defineProperty(exports,"__esModule",{value:!0}),exports.default=void 0;var _slicedToArray2=_interopRequireDefault(__webpack_require__("3835"));__webpack_require__("ac6a"),__webpack_require__("cadf"),__webpack_require__("551c"),__webpack_require__("097d");var _board=__webpack_require__("fb4e"),_Disc=_interopRequireDefault(__webpack_require__("357c")),_player=_interopRequireDefault(__webpack_require__("e5a2")),_i18n=_interopRequireDefault(__webpack_require__("f4a7")),worker;worker=new _player.default;var _default={props:["user","level","guide","message","back","set_undo_btn"],data:function(){return{board:new _board.Board,turn:_board.BLACK,flips:[],hover_at:null,undo_stack:[],thinking:!1,user_moves:0,gameover:!1,will_flip_enabled:!1,BLACK:_board.BLACK,i18n:_i18n.default}},mounted:function(){return worker.postMessage({type:"set_level",level:this.level}),this.turn===this.user?this.message({text:this.i18n.your_turn}):this.worker_move()},updated:function(){return this.$el.classList.add("animate")},computed:{can_undo:function(){return!this.thinking&&this.user_moves&&!this.gameover},rows:function(){var e,t,n,r=this;return t=function(){var t,r,a=this;for(r=[],n=t=0;t<8;n=++t)e=[],[0,1,2,3,4,5,6,7].forEach(function(t){var r,i;return i=(0,_board.pos_from_xy)(t,n),r=a.board.get(i),e.push({disc:r===_board.BLACK?"black":r===_board.WHITE?"white":null,can_move:a.turn===a.user&&a.board.can_move(a.turn,i),is_hover:a.turn===a.user&&(a.hover_at===i&&a.board.can_move(a.turn,i)),will_flip:a.will_flip_enabled&&a.flips.indexOf(i)>=0,move:function(){if(a.turn===a.user)return a.move(i)},enter:function(){if(a.turn===a.user)return a.flips=a.board.move(a.turn,i),a.flips.length&&(a.board.undo(a.turn,i,a.flips),a.hover_at=i),a.will_flip_enabled=!1},leave:function(){return a.hover_at=null,a.flips=[],a.will_flip_enabled=!1}})}),r.push(e);return r}.call(this),setTimeout(function(){return r.will_flip_enabled=!0},50),t}},methods:{move:function move(pos){var _this3=this,discs,flips,outcome;if(this.flips=[],this.hover_at=null,flips=this.board.move(this.turn,pos),flips.length)return this.undo_stack.push([this.turn,pos,flips]),this.turn===this.user&&this.user_moves++,this.turn=-this.turn,this.board.any_moves(this.turn)?this.turn===this.user?this.message({text:this.i18n.your_turn}):this.worker_move():(this.turn=-this.turn,this.board.any_moves(this.turn)?this.turn===this.user?this.message({text:this.i18n.i_pass}):this.message({text:this.i18n.you_pass,pass:function(){return _this3.worker_move()}}):(this.gameover=!0,outcome=this.board.outcome(this.user),discs="".concat(this.board.count(this.user),":").concat(this.board.count(-this.user)),outcome>0?this.message({text:eval("`"+this.i18n.win+"`"),back:this.back}):outcome<0?this.message({text:eval("`"+this.i18n.lose+"`"),back:this.back}):this.message({text:this.i18n.draw,back:this.back})))},worker_move:function(){var e,t=this;return this.message({text:this.i18n.thinking,spin:!0}),e=Date.now(),worker.onmessage=function(n){var r,a;worker.onmessage=null,e=Date.now()-e,console.log("".concat(e," msec"));var i=n.data;return r=i.move,a=i.value,null!=a&&console.log("Estimated value",Math.round(100*a)/100),setTimeout(function(){return t.move(r),t.thinking=!1},e<1e3?1e3-e:0)},this.thinking=!0,worker.postMessage({type:"move",board:this.board.dump(),turn:this.turn})},undo:function(){var e,t,n;if(!this.can_undo)throw new Error("cannot undo");while(1){var r=this.undo_stack.pop(),a=(0,_slicedToArray2.default)(r,3);if(n=a[0],t=a[1],e=a[2],this.board.undo(n,t,e),n===this.user)break}return this.user_moves--,this.board.board.push(0),this.board.board.pop()}},watch:{can_undo:function(){return this.set_undo_btn(this.can_undo,this.undo)}},components:{Disc:_Disc.default}};exports.default=_default},"89a8":function(e,t,n){"use strict";n.r(t);var r=n("94ff"),a=n.n(r);for(var i in r)"default"!==i&&function(e){n.d(t,e,function(){return r[e]})}(i);t["default"]=a.a},"89c4":function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("097d");var r={props:["color","will_flip"]};t.default=r},"8fba":function(e,t,n){},"91ea":function(e,t,n){"use strict";n.r(t);var r=n("00a7"),a=n("f0a0");for(var i in a)"default"!==i&&function(e){n.d(t,e,function(){return a[e]})}(i);n("a937");var o=n("2877"),u=Object(o["a"])(a["default"],r["a"],r["b"],!1,null,"f6922c16",null);u.options.__file="Board.vue",t["default"]=u.exports},"92af":function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"box"},[n("div",{staticClass:"text"},[e.spin?n("Spinner",{staticClass:"spinner"}):e._e(),e._v(e._s(e.text))],1),e.pass||e.back?n("div",{staticClass:"action"},[e.pass?n("Button",{attrs:{theme:"light"},on:{click:e.pass}},[e._v(e._s(e.i18n.pass))]):e._e(),e.back?n("Button",{attrs:{theme:"light"},on:{click:e.back}},[e._v(e._s(e.i18n.play_again))]):e._e()],1):e._e()])},a=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return a})},"94ff":function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("097d");var r={props:["theme","border"],computed:{className:function(){var e;return[this.theme||"dark",null==(e=this.border)||e?"border":null]}}};t.default=r},"9d62":function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("svg",{class:[e.will_flip&&"flip",e.color],attrs:{viewBox:"0 0 100 100"}},[n("circle",{attrs:{cx:"50",cy:"50",r:"50"}})])},a=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return a})},"9d6c":function(e,t,n){"use strict";var r=n("4ea4");Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("097d");var a=r(n("2375")),i=r(n("2a7d")),o=r(n("f4a7")),u={props:["text","pass","back","spin"],data:function(){return{i18n:o.default}},components:{Spinner:a.default,Button:i.default}};t.default=u},"9ed8":function(e,t,n){},a460:function(e,t,n){},a937:function(e,t,n){"use strict";var r=n("ed85"),a=n.n(r);a.a},b823:function(e,t,n){"use strict";n.r(t);var r=n("9d6c"),a=n.n(r);for(var i in r)"default"!==i&&function(e){n.d(t,e,function(){return r[e]})}(i);t["default"]=a.a},bc83:function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("button",{class:e.className,on:{click:function(t){e.$emit("click")}}},[e._t("default")],2)},a=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return a})},be17:function(e,t,n){"use strict";var r=n("4ea4");Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("097d");var a=n("fb4e"),i=r(n("357c"));n("d48d");var o,u,s=r(n("576b")),c=r(n("8ca1")),l=r(n("2a7d")),f=r(n("f4a7"));u=function(e,t){return localStorage["_oth_"+e]=JSON.stringify(t)},o=function(e,t){var n;return n=localStorage["_oth_"+e],null!=n?JSON.parse(n):t};var d={props:["start"],data:function(){return{levels:["easiest","easy","normal","hard","hardest"],color:o("color",a.BLACK),level:o("level","normal"),guide:o("guide",!0),BLACK:a.BLACK,WHITE:a.WHITE,i18n:f.default}},methods:{submit:function(){return u("color",this.color),u("level",this.level),u("guide",this.guide),this.start(this.color,this.level,this.guide)}},components:{Disc:i.default,CheckboxMarked:s.default,CheckboxBlankOutline:c.default,Button:l.default}};t.default=d},ca1a:function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"screen"},[n("header",[n("Button",{staticClass:"back",attrs:{border:!1},on:{click:e.back}},[n("ArrowLeftThick")],1),n("div",{staticClass:"level"},[e._v(e._s(e.level_title))]),n("Button",{staticClass:"undo",attrs:{disabled:!e.undo_enabled},on:{click:e.undo}},[e._v(e._s(e.i18n.undo))])],1),n("main",[n("Board",{staticClass:"board",attrs:{user:e.user,level:e.level,guide:e.guide,message:e.show_message,back:e.back,set_undo_btn:e.set_undo_btn}}),n("div",{staticClass:"msg-box-wrapper"},[n("transition",{attrs:{name:"msg"}},[e.msg?n("MessageBox",e._b({key:e.msg_key,staticClass:"msg-box"},"MessageBox",e.msg,!1)):e._e()],1)],1)],1)])},a=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return a})},cff4:function(e,t,n){},e2ec:function(e,t,n){"use strict";n.r(t);var r=n("eaf8"),a=n.n(r);for(var i in r)"default"!==i&&function(e){n.d(t,e,function(){return r[e]})}(i);t["default"]=a.a},e5a2:function(e,t,n){e.exports=function(){return new Worker(n.p+"js/worker.ef2ed11230d45ee4e599.js")}},eaf8:function(module,exports,__webpack_require__){"use strict";var _interopRequireDefault=__webpack_require__("4ea4");Object.defineProperty(exports,"__esModule",{value:!0}),exports.default=void 0,__webpack_require__("cadf"),__webpack_require__("551c"),__webpack_require__("097d");var _ArrowLeftThick=_interopRequireDefault(__webpack_require__("99b8")),_Board=_interopRequireDefault(__webpack_require__("91ea")),_MessageBox=_interopRequireDefault(__webpack_require__("521f")),_Button=_interopRequireDefault(__webpack_require__("2a7d")),_i18n=_interopRequireDefault(__webpack_require__("f4a7")),_default={props:["user","level","guide","back"],data:function(){return{msg:null,msg_key:0,undo_enabled:!1,undo:function(){},i18n:_i18n.default}},computed:{level_title:function level_title(){var mode;return mode=_i18n.default[this.level],eval("`"+_i18n.default.mode+"`")}},methods:{show_message:function(e){return this.msg_key++,this.msg=e},set_undo_btn:function(e,t){return this.undo_enabled=e,this.undo=t}},components:{ArrowLeftThick:_ArrowLeftThick.default,Board:_Board.default,MessageBox:_MessageBox.default,Button:_Button.default}};exports.default=_default},ed85:function(e,t,n){},f0a0:function(e,t,n){"use strict";n.r(t);var r=n("85a1"),a=n.n(r);for(var i in r)"default"!==i&&function(e){n.d(t,e,function(){return r[e]})}(i);t["default"]=a.a},f0fa:function(e,t,n){"use strict";var r=n("03a8"),a=n.n(r);a.a},f346:function(e,t,n){"use strict";(function(t){var r=n("4ea4");n("aef6"),n("551c"),n("ac6a"),n("5df3"),n("f400"),n("cadf");var a,i,o,u,s,c,l,f=r(n("2909"));n("097d"),l=function(e){var t,n,r,a,i;for(e=(0,f.default)(e),r=e.length,t=n=r-1;n>0;t=n+=-1)a=Math.random()*(t+1)|0,i=e[t],e[t]=e[a],e[a]=i;return e},u=function(e){var t;return t=new Map,function(){for(var n,r=arguments.length,a=new Array(r),i=0;i<r;i++)a[i]=arguments[i];return n=t.get(a),void 0===n&&(n=e.apply(void 0,a),t.set(a,n)),n}},i=function(e){return 0|e},s=function(e,r){return new Promise(function(a){var i,o;return"-"===e?o=t.stdin:(o=n("3e8f").createReadStream(e),e.endsWith(".gz")&&(o=o.pipe(n("3e8f").createGunzip()))),i=n("3e8f").createInterface(o),i.on("line",function(e){return r(e)}),i.on("close",function(){return a()})})},a=function(e){var r,a;return"-"===e?t.stdout:(a=n("3e8f").createWriteStream(e),e.endsWith(".gz")?(r=n("3e8f").createGzip(),r.pipe(a),r):a)},o=function(e){var t,n,r,a,i,o,u,s;return t={},r={},r.prev=r.next=r,u=0,a=0,o=0,n=0,s=function(e){return e.next.prev=e.prev,e.prev.next=e.next},i=function(e){return e.prev=r,e.next=r.next,r.next.prev=e,r.next=e},{put:function(a,o){var c,l;return c=t[a],c?s(c):u>=e?(n+=1,l=r.prev,s(l),delete t[l.key]):u++,c={key:a,data:o},i(c),t[a]=c},get:function(e){var n;return n=t[e],n?(a+=1,n!==r.next&&(s(n),i(n)),n.data):(o+=1,null)},stats:function(){return{n:u,hit:a,miss:o,evict:n}}}},c=function(e){return Math.round(1e4*e)/1e4},e.exports={shuffle:l,memoize:u,int:i,readlines:s,gzwriter:a,lru_cache:o,round_value:c}}).call(this,n("4362"))},f4a7:function(e,t,n){"use strict";var r,a,i,o,u,s=n("4ea4"),c=s(n("3835"));n("28a5"),n("386d"),n("cadf"),n("551c"),n("097d"),u={en:{first_move:"First move",second_move:"Second move",show_guide:"Show guide",start:"Start",undo:"Undo",your_turn:"Your turn.",thinking:"Thinking...",you_pass:"You have no moves.",pass:"Pass",i_pass:"I have no moves. Your turn.",win:"You won by ${discs}!",lose:"You lost by ${discs}!",draw:"Draw!",play_again:"Play Again",easiest:"Easiest",easy:"Easy",normal:"Normal",hard:"Hard",hardest:"Hardest",mode:"${mode} mode"},ja:{first_move:"先手",second_move:"後手",show_guide:"ガイドを表示する",start:"スタート",undo:"待った",your_turn:"あなたの番です",thinking:"考えています...",you_pass:"あなたの打てるところがありません",pass:"パス",i_pass:"私の打てるところがありません。あなたの番です",win:"${discs}であなたの勝ちです!",lose:"${discs}であなたの負けです!",draw:"引き分け!",play_again:"もう一度プレイする",easiest:"超イージー",easy:"イージー",normal:"ノーマル",hard:"ハード",hardest:"超ハード",mode:"${mode}モード"}},i=function(){var e,t,n,r,a,i,o,u=arguments.length>0&&void 0!==arguments[0]?arguments[0]:window.location.search;for("?"===u[0]&&(u=u.substr(1)),i={},a=u.split("&"),e=0,r=a.length;e<r;e++){n=a[e];var s=n.split("="),l=(0,c.default)(s,2);t=l[0],o=l[1],t=decodeURIComponent(t),o=decodeURIComponent(o),i[t]=o}return i},a=i(),r=a.lang,r?localStorage._oth_lang=a.lang:r=localStorage._oth_lang||(null!=(o=window.navigator.languages)?o[0]:void 0)||window.navigator.language||window.navigator.userLanguage||window.navigator.browserLanguage,u[r]||(r="en"),e.exports=u[r],e.exports.lang=r},f571:function(e,t,n){"use strict";n.r(t);var r=n("be17"),a=n.n(r);for(var i in r)"default"!==i&&function(e){n.d(t,e,function(){return r[e]})}(i);t["default"]=a.a},fb4e:function(e,t,n){"use strict";var r=n("4ea4");n("28a5");var a,i,o,u,s,c,l,f,d,_,v,h,p,b,m,g,k,w,y,x,C,B,A=r(n("2909")),O=r(n("d4ec")),q=r(n("bee2"));n("ac6a"),n("5df3"),n("f400"),n("cadf"),n("551c"),n("097d");var j=n("f346");m=j.int,c=0,o=1,v=-1,l=2,y=function(e,t){return 9*(t+1)+(e+1)},w=function(e){var t,n;if(t=e.toLowerCase().charCodeAt(0)-"a".charCodeAt(0),n=parseInt(e[1])-1,t<0||t>7||n<0||n>7)throw new Error("invalid position string");return y(t,n)},C=function(e){return{x:e%9-1,y:m(e/9)-1}},x=function(e){var t,n,r,a=arguments.length>1&&void 0!==arguments[1]?arguments[1]:o,i=C(e);return n=i.x,r=i.y,t=a===o?"A":"a",String.fromCharCode(t.charCodeAt(0)+n)+(r+1)},g=function(e){var t,n,r;n=/([a-hA-H][1-8])/g,r=[];while(1){if(t=n.exec(e),!t)break;r.push(w(t[0]))}return r},k=function(e){return e.map(function(e){return x(e)}).join("")},p={"-":c,X:o,O:v},b=function(e){return p[e]},B=function(){var e,t,n;return t=new Map(function(){var t;for(e in t=[],p)n=p[e],t.push([n,e]);return t}()),function(e){return t.get(e)||"?"}}(),i=function(){var e,t,n,r,a;for(n=[],a=e=0;e<=7;a=++e)for(r=t=0;t<=7;r=++t)n.push(y(r,a));return n}(),h=[],h[w("B2")]=!0,h[w("G2")]=!0,h[w("B7")]=!0,h[w("G7")]=!0,_=-9,s=9,f=-1,d=1,a=[_+f,_,_+d,f,d,s+f,s,s+d],function(){var e,t,n,r,a,i,o,u;for(e=["A1","C1","A3","D1","A4","C3","D3","C4","D2","B4","B1","A2","C2","B3","B2","D4"],r=[],t=0,n=e.length;t<n;t++){i=e[t],a=w(i);var s=C(a);o=s.x,u=s.y,r.push(y(o,u)),r.push(y(7-o,u)),r.push(y(o,7-u)),r.push(y(7-o,7-u))}}(),u=function(){function e(t){(0,O.default)(this,e),t?"string"===typeof t?this.load(t):(this.board=(0,A.default)(t.board),this.build_empty_list()):this.load("- - - - - - - -\n- - - - - - - -\n- - - - - - - -\n- - - O X - - -\n- - - X O - - -\n- - - - - - - -\n- - - - - - - -\n- - - - - - - -")}return(0,q.default)(e,[{key:"load",value:function(e){var t,n,r,a,i,o,u,s,f;for(t=l,r=c,this.board=[t,t,t,t,t,t,t,t,t,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,t,t,t,t,t,t,t,t,t],s=0,f=0,o=e.split(""),a=0,i=o.length;a<i;a++)if(n=o[a],u=b(n),"undefined"!==typeof u){if(f>=8)throw new Error("too many cells");this.board[y(s,f)]=u,++s>=8&&(s=0,f++)}if(f<8)throw new Error("too few cells");return this.build_empty_list()}},{key:"dump",value:function(){var e,t,n,r,a,i,o,u=arguments.length>0&&void 0!==arguments[0]&&arguments[0];if(r=[],u){for(r.push(" "),i=e=0;e<=7;i=++e)r.push(" "),r.push(String.fromCharCode("A".charCodeAt(0)+i));r.push("\n")}for(o=t=0;t<=7;o=++t){for(u&&(r.push(o+1),r.push(" ")),i=n=0;n<=7;i=++n)r.push(B(this.board[y(i,o)])||"?"),u&&r.push(" ");u&&r.push(o+1),u&&r.push("\n")}if(u)for(r.push(" "),i=a=0;a<=7;i=++a)r.push(" "),r.push(String.fromCharCode("A".charCodeAt(0)+i));return r.join("")}},{key:"get",value:function(e){return this.board[e]}},{key:"count",value:function(e){var t,n=this;return t=0,i.forEach(function(r){if(n.board[r]===e)return t++}),t}},{key:"can_move",value:function(e,t){var n,r,i,o,u;if(this.board[t]===c)for(r=-e,i=0,o=a.length;i<o;i++)if(n=a[i],u=t+n,this.board[u]===r){u+=n;while(this.board[u]===r)u+=n;if(this.board[u]===e)return!0}return!1}},{key:"any_moves",value:function(e){var t,n=this;return t=!1,this.each_empty(function(r){if(n.can_move(e,r))return t=!0,!1}),t}},{key:"list_moves",value:function(e){var t,n=this;return t=[],this.each_empty(function(r){if(n.can_move(e,r))return t.push(r)}),t}},{key:"list_moves_but_x",value:function(e){var t,n=this;return t=[],this.each_empty(function(r){if(!h[r]&&n.can_move(e,r))return t.push(r)}),t}},{key:"move",value:function(e,t){var n,r,i,o,u,s,l=!(arguments.length>2&&void 0!==arguments[2])||arguments[2];if(r=[],this.board[t]===c){for(i=-e,o=0,u=a.length;o<u;o++)if(n=a[o],s=t+n,this.board[s]===i){s+=n;while(this.board[s]===i)s+=n;if(this.board[s]===e)while((s-=n)!==t)this.board[s]=e,r.push(s)}r.length&&(this.board[t]=e,l&&this.pop_empty_list(t))}return r}},{key:"count_flips",value:function(e,t){var n,r,i,o,u,s,l;if(r=0,this.board[t]===c)for(i=-e,o=0,u=a.length;o<u;o++){n=a[o],l=t+n,s=0;while(this.board[l]===i)l+=n,s++;this.board[l]===e&&(r+=s)}return r}},{key:"undo",value:function(e,t,n){var r,a,i,o,u=!(arguments.length>3&&void 0!==arguments[3])||arguments[3];for(r=-e,a=0,i=n.length;a<i;a++)o=n[a],this.board[o]=r;if(this.board[t]=c,u)return this.push_empty_list(t)}},{key:"score",value:function(e){var t,n,r=this;return t=-e,n=0,i.forEach(function(a){switch(r.board[a]){case e:return n++;case t:return n--}}),n}},{key:"outcome",value:function(){var e,t,n,r=this,a=arguments.length>0&&void 0!==arguments[0]?arguments[0]:o;return t=-a,n=0,e=0,i.forEach(function(i){switch(r.board[i]){case a:return n++;case t:return n--;case c:return e++}}),e&&(n>0?n+=e:n<0&&(n-=e)),n}},{key:"build_empty_list",value:function(){var e,t=this;return this.empty_next=[0],this.empty_prev=[0],e=0,i.forEach(function(n){if(t.board[n]===c)return t.empty_next[e]=n,t.empty_prev[n]=e,e=n}),this.empty_next[e]=0}},{key:"pop_empty_list",value:function(e){return this.empty_next[this.empty_prev[e]]=this.empty_next[e],this.empty_prev[this.empty_next[e]]=this.empty_prev[e]}},{key:"push_empty_list",value:function(e){return this.empty_next[this.empty_prev[e]]=e,this.empty_prev[this.empty_next[e]]=e}},{key:"first_empty",value:function(){return this.empty_next[0]}},{key:"each_empty",value:function(e){var t,n;t=0,n=[];while(1){if(t=this.empty_next[t],0===t)break;if(!1===e(t))break;n.push(void 0)}return n}},{key:"validate_empty_list",value:function(){var e,t,n=this;return t=0,this.each_empty(function(e){return console.assert(n.board[e]===c),t++}),e=0,i.forEach(function(t){if(n.board[t]===c)return e++}),console.assert(t===e)}}]),e}(),e.exports={EMPTY:c,BLACK:o,WHITE:v,GUARD:l,ALL_POSITIONS:i,UP:_,DOWN:s,LEFT:f,RIGHT:d,pos_from_xy:y,pos_from_str:w,pos_to_xy:C,pos_to_str:x,pos_array_from_str:g,pos_array_to_str:k,square_to_char:B,char_to_square:b,Board:u}}});
//# sourceMappingURL=app.1a8215cc.js.map