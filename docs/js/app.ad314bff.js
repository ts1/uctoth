(function(t){function e(e){for(var r,a,i=e[0],u=e[1],c=e[2],f=0,d=[];f<i.length;f++)a=i[f],o[a]&&d.push(o[a][0]),o[a]=0;for(r in u)Object.prototype.hasOwnProperty.call(u,r)&&(t[r]=u[r]);l&&l(e);while(d.length)d.shift()();return s.push.apply(s,c||[]),n()}function n(){for(var t,e=0;e<s.length;e++){for(var n=s[e],r=!0,i=1;i<n.length;i++){var u=n[i];0!==o[u]&&(r=!1)}r&&(s.splice(e--,1),t=a(a.s=n[0]))}return t}var r={},o={app:0},s=[];function a(e){if(r[e])return r[e].exports;var n=r[e]={i:e,l:!1,exports:{}};return t[e].call(n.exports,n,n.exports,a),n.l=!0,n.exports}a.m=t,a.c=r,a.d=function(t,e,n){a.o(t,e)||Object.defineProperty(t,e,{enumerable:!0,get:n})},a.r=function(t){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},a.t=function(t,e){if(1&e&&(t=a(t)),8&e)return t;if(4&e&&"object"===typeof t&&t&&t.__esModule)return t;var n=Object.create(null);if(a.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var r in t)a.d(n,r,function(e){return t[e]}.bind(null,r));return n},a.n=function(t){var e=t&&t.__esModule?function(){return t["default"]}:function(){return t};return a.d(e,"a",e),e},a.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},a.p="/uctoth/";var i=window["webpackJsonp"]=window["webpackJsonp"]||[],u=i.push.bind(i);i.push=e,i=i.slice();for(var c=0;c<i.length;c++)e(i[c]);var l=u;s.push([0,"chunk-vendors"]),n()})({0:function(t,e,n){t.exports=n("56d7")},"0130":function(t,e,n){"use strict";n.r(e);var r=n("89c4"),o=n.n(r);for(var s in r)"default"!==s&&function(t){n.d(e,t,function(){return r[t]})}(s);e["default"]=o.a},"03cd":function(t,e,n){},"1fb2":function(t,e,n){"use strict";n("cadf"),n("551c"),n("f751"),n("097d"),t.exports={props:{moves:{required:!0}},data:function(){return{moves_:"",i18n:n("f4a7")}},watch:{moves:function(){var t=this;return this.$nextTick(function(){return t.$refs.input.scrollLeft=9999})}}}},2375:function(t,e,n){"use strict";n.r(e);var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("svg",{staticClass:"spinner",attrs:{viewBox:"0 0 100 100"}},[n("circle",{attrs:{cx:"50",cy:"50",fill:"none",stroke:"currentColor","stroke-width":"7",r:"35","stroke-dasharray":"200 20"}})])},o=[],s=(n("3e51"),n("2877")),a={},i=Object(s["a"])(a,r,o,!1,null,"2aca0085",null);e["default"]=i.exports},"25e0":function(t,e,n){"use strict";n.r(e);var r=n("8150"),o=n("e2ec");for(var s in o)"default"!==s&&function(t){n.d(e,t,function(){return o[t]})}(s);n("72f6");var a=n("2877"),i=Object(a["a"])(o["default"],r["a"],r["b"],!1,null,"b194b9aa",null);e["default"]=i.exports},2691:function(t,e,n){"use strict";var r=n("8423"),o=n.n(r);o.a},"27c5":function(t,e,n){"use strict";n.r(e);var r=n("d341"),o=n("f571");for(var s in o)"default"!==s&&function(t){n.d(e,t,function(){return o[t]})}(s);n("a321");var a=n("2877"),i=Object(a["a"])(o["default"],r["a"],r["b"],!1,null,"da15c862",null);e["default"]=i.exports},"2a7d":function(t,e,n){"use strict";n.r(e);var r=n("bc83"),o=n("89a8");for(var s in o)"default"!==s&&function(t){n.d(e,t,function(){return o[t]})}(s);n("7d37");var a=n("2877"),i=Object(a["a"])(o["default"],r["a"],r["b"],!1,null,"4ba721ed",null);e["default"]=i.exports},"2a90":function(t,e,n){"use strict";var r=n("288e");Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d"),n("494d");var o=r(n("27c5")),s=r(n("25e0")),a={name:"app",data:function(){return{mode:"setting",color:null,level:null,guide:null,moves:null}},methods:{start:function(t,e,n,r){return this.color=t,this.level=e,this.guide=n,this.moves=r,this.mode="game"},back:function(){return this.mode="setting"}},components:{Setting:o.default,Game:s.default}};e.default=a},"2ba8":function(t,e,n){"use strict";var r=n("288e");Object.defineProperty(e,"__esModule",{value:!0}),e.default=d,e.mute=e.is_muted=e.is_supported=void 0,n("7f7f"),n("96cf");var o,s,a,i,u,c,l=r(n("3b8d")),f=r(n("795b"));function d(t){return v.apply(this,arguments)}function v(){return v=(0,l.default)(regeneratorRuntime.mark(function t(e){var n,r;return regeneratorRuntime.wrap(function(t){while(1)switch(t.prev=t.next){case 0:if(!u){t.next=2;break}return t.abrupt("return");case 2:if(!s){t.next=15;break}if(n=c[e],n){t.next=6;break}throw new Error("sound ".concat(e," is not loaded"));case 6:return r=s.createBufferSource(),r.loop=!1,t.next=10,n;case 10:return r.buffer=t.sent,r.connect(s.destination),t.abrupt("return",r.start(0));case 15:return t.abrupt("return",c[e].play());case 16:case"end":return t.stop()}},t,this)})),v.apply(this,arguments)}n("551c"),n("cadf"),n("f751"),n("097d"),c={},s=null,u=!1,o=window.AudioContext||window.webkitAudioContext,i=function(t){return c.move=t(n("cff9"))},o?(a=function(){if(!s)return s=new o,s.resume(),i(function(t){return new f.default(function(e,n){var r;return r=new XMLHttpRequest,r.open("GET",t),r.responseType="arraybuffer",r.onload=function(){return 200===r.status?s.decodeAudioData(r.response,function(t){return e(t)}):(console.dir(r),n(new Error("error loading ".concat(t))))},r.send()})}),window.removeEventListener("touchstart",a),window.removeEventListener("click",a)},window.addEventListener("touchstart",a),window.addEventListener("click",a)):i(function(t){var e;return e=document.createElement("audio"),e.src=n("cff9"),e.preload="auto",document.body.appendChild(e),e});var h=function(){return!0};e.is_supported=h;var m=function(){return u};e.is_muted=m;var p=function(t){return u=t};e.mute=p},"357c":function(t,e,n){"use strict";n.r(e);var r=n("6f2a"),o=n("0130");for(var s in o)"default"!==s&&function(t){n.d(e,t,function(){return o[t]})}(s);n("b1bb");var a=n("2877"),i=Object(a["a"])(o["default"],r["a"],r["b"],!1,null,"5770404b",null);e["default"]=i.exports},"3dfd":function(t,e,n){"use strict";var r=n("c432"),o=n("6593"),s=(n("7faf"),n("2877")),a=Object(s["a"])(o["default"],r["a"],r["b"],!1,null,null,null);e["default"]=a.exports},"3e51":function(t,e,n){"use strict";var r=n("03cd"),o=n.n(r);o.a},"521f":function(t,e,n){"use strict";n.r(e);var r=n("68a9"),o=n("b823");for(var s in o)"default"!==s&&function(t){n.d(e,t,function(){return o[t]})}(s);n("a58c");var a=n("2877"),i=Object(a["a"])(o["default"],r["a"],r["b"],!1,null,"f2df1764",null);e["default"]=i.exports},"56d7":function(t,e,n){"use strict";n.r(e);n("cadf"),n("551c"),n("f751"),n("097d");var r=n("2b0e"),o=n("3dfd");r["a"].config.productionTip=!1,new r["a"]({render:function(t){return t(o["default"])}}).$mount("#app")},"5c38":function(t,e,n){},6593:function(t,e,n){"use strict";var r=n("2a90"),o=n.n(r);e["default"]=o.a},"68a9":function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"box",class:t.error&&"error"},[n("div",{staticClass:"text"},[t.spin?n("Spinner",{staticClass:"spinner"}):t._e(),t._v(t._s(t.text))],1),t.pass||t.back?n("div",{staticClass:"action"},[t.pass?n("Button",{attrs:{theme:"light"},on:{click:t.pass}},[t._v(t._s(t.i18n.pass))]):t._e(),t.back?n("Button",{attrs:{theme:"light"},on:{click:t.back}},[t._v(t._s(t.i18n.play_again))]):t._e()],1):t._e()])},o=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return o})},6965:function(t,e,n){"use strict";n.r(e);var r=n("1fb2"),o=n.n(r);for(var s in r)"default"!==s&&function(t){n.d(e,t,function(){return r[t]})}(s);e["default"]=o.a},"6e54":function(t,e,n){"use strict";var r=n("b253"),o=n.n(r);o.a},"6f2a":function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"wrapper",class:[t.will_flip&&"flip",t.color]},[n("svg",{attrs:{viewBox:"0 0 100 100",fill:"currentColor"}},[n("circle",{attrs:{cx:"50",cy:"50",r:"50"}})])])},o=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return o})},"72f6":function(t,e,n){"use strict";var r=n("cedd"),o=n.n(r);o.a},"7d37":function(t,e,n){"use strict";var r=n("9ed8"),o=n.n(r);o.a},"7faf":function(t,e,n){"use strict";var r=n("8fba"),o=n.n(r);o.a},8150:function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"screen"},[n("header",[n("div",{staticClass:"icons"},[n("Button",{attrs:{border:!1},on:{click:t.back}},[n("BackIcon")],1),t.sound_supported?n("Button",{attrs:{border:!1},on:{click:t.mute}},[t.muted?t._e():n("SoundIcon"),t.muted?n("MuteIcon"):t._e()],1):t._e()],1),n("div",{staticClass:"level"},[t._v(t._s(t.level_title))]),n("Button",{staticClass:"undo",attrs:{disabled:!t.undo_enabled},on:{click:t.undo}},[t._v(t._s(t.i18n.undo))])],1),n("main",[n("Board",{staticClass:"board",attrs:{user:t.user,level:t.level,guide:t.guide,message:t.show_message,back:t.back,set_undo_btn:t.set_undo_btn,entered_moves:t.entered_moves},on:{"add-move":function(e){return t.add_move(e)},undo:t.undo_move,"reset-moves":t.reset_moves}}),t.show_moves?n("Moves",{staticClass:"moves",attrs:{moves:t.moves},on:{"enter-moves":function(e){return t.enter_moves(e)}}}):t._e(),n("div",{staticClass:"msg-box-wrapper"},[n("transition",{attrs:{name:"msg"}},[t.msg?n("MessageBox",t._b({key:t.msg_key,staticClass:"msg-box"},"MessageBox",t.msg,!1)):t._e()],1)],1)],1),n("div",{staticClass:"filler"})])},o=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return o})},8423:function(t,e,n){},"85a1":function(t,e,n){"use strict";var r=n("288e");Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf");var o=r(n("768b")),s=r(n("0a0d"));n("ac6a"),n("551c"),n("f751"),n("097d");var a,i=n("fb4e"),u=r(n("357c")),c=r(n("e5a2")),l=r(n("f4a7")),f=r(n("2ba8"));a=new c.default;var d={props:["user","level","guide","message","back","set_undo_btn","entered_moves"],data:function(){return{board:new i.Board,turn:i.BLACK,flips:[],hover_at:null,undo_stack:[],thinking:!1,user_moves:0,gameover:!1,will_flip_enabled:!1,keys:[],BLACK:i.BLACK,i18n:l.default}},mounted:function(){var t=this;return a.postMessage({type:"set_level",level:this.level}),this.turn===this.user?this.message({text:this.i18n.your_turn}):this.worker_move(),gtag("event","start",{event_category:"game",event_label:this.level}),this.key_listener=function(e){return t.keypress(e)},window.addEventListener("keypress",this.key_listener)},beforeDestroy:function(){return window.removeEventListener("keypress",this.key_listener)},updated:function(){return this.$el.classList.add("animate")},computed:{can_undo:function(){return!this.thinking&&this.user_moves&&!this.gameover},rows:function(){var t,e,n,r=this;return e=function(){var e,r,o=this;for(r=[],n=e=0;e<8;n=++e)t=[],[0,1,2,3,4,5,6,7].forEach(function(e){var r,s;return s=(0,i.pos_from_xy)(e,n),r=o.board.get(s),t.push({disc:r===i.BLACK?"black":r===i.WHITE?"white":null,can_move:o.turn===o.user&&o.board.can_move(o.turn,s),is_hover:o.turn===o.user&&(o.hover_at===s&&o.board.can_move(o.turn,s)),will_flip:o.will_flip_enabled&&o.flips.indexOf(s)>=0,move:function(){if(o.turn===o.user)return o.move(s)},enter:function(){if(o.turn===o.user)return o.flips=o.board.move(o.turn,s),o.flips.length&&(o.board.undo(o.turn,s,o.flips),o.hover_at=s),o.will_flip_enabled=!1},leave:function(){return o.hover_at=null,o.flips=[],o.will_flip_enabled=!1}})}),r.push(t);return r}.call(this),setTimeout(function(){return r.will_flip_enabled=!0},50),e}},methods:{move:function(t){var e;if(this.flips=[],this.hover_at=null,e=this.board.move(this.turn,t),e.length)return(0,f.default)("move"),this.$emit("add-move",(0,i.pos_to_str)(t,this.turn)),this.undo_stack.push([this.turn,t,e]),this.turn===this.user&&this.user_moves++,this.turn=-this.turn,this.after_move()},after_move:function(){var t,e,n=this;return this.board.any_moves(this.turn)?this.turn===this.user?this.message({text:this.i18n.your_turn}):this.worker_move():(this.turn=-this.turn,this.board.any_moves(this.turn)?this.turn===this.user?this.message({text:this.i18n.i_pass}):this.message({text:this.i18n.you_pass,pass:function(){return n.worker_move()}}):(this.gameover=!0,e=this.board.outcome(this.user),t="".concat(this.board.count(this.user),":").concat(this.board.count(-this.user)),e>0?(this.message({text:l.default.expand("win",{discs:t}),back:this.back}),gtag("event","win",{event_category:"game",event_label:this.level,value:e})):e<0?(this.message({text:l.default.expand("lose",{discs:t}),back:this.back}),gtag("event","lose",{event_category:"game",event_label:this.level,value:e})):(this.message({text:this.i18n.draw,back:this.back}),gtag("event","draw",{event_category:"game",event_label:this.level,value:e}))))},worker_move:function(){var t,e=this;return this.message({text:this.i18n.thinking,spin:!0}),t=(0,s.default)(),a.onmessage=function(n){var r,o;a.onmessage=null,t=(0,s.default)()-t,console.log("".concat(t," msec"));var u=n.data;return r=u.move,o=u.value,console.log("Move",(0,i.pos_to_str)(r)),null!=o&&console.log("Estimated value",Math.round(100*o)/100),setTimeout(function(){return e.move(r),e.thinking=!1},t<2e3?2e3-t:0)},this.thinking=!0,a.postMessage({type:"move",board:this.board.dump(),turn:this.turn})},undo:function(){var t,e,n;if(!this.can_undo)throw new Error("cannot undo");while(1){var r=this.undo_stack.pop(),s=(0,o.default)(r,3);if(n=s[0],e=s[1],t=s[2],this.board.undo(n,e,t),this.$emit("undo"),n===this.user)break}return this.user_moves--,this.turn!==this.user&&(this.turn=this.user,this.message({text:this.i18n.your_turn})),this.board.board.push(0),this.board.board.pop()},keypress:function(t){var e,n;if("INPUT"!==t.target.nodeName){this.keys.push(t.key),this.keys=this.keys.slice(-2),n=this.keys.join("");try{e=(0,i.pos_from_str)(n)}catch(r){e=0}return e&&this.turn===this.user&&this.board.can_move(this.user,e)?this.move(e):void 0}}},watch:{can_undo:function(){return this.set_undo_btn(this.can_undo,this.undo)},entered_moves:function(){var t,e,n,r,o,s,a;for(o=(0,i.pos_array_from_str)(this.entered_moves),this.$emit("reset-moves"),this.board=new i.Board,s=!1,a=i.BLACK,e=0,n=o.length;e<n;e++){if(r=o[e],t=this.board.move(a,r),0===t.length){s=!1;break}this.$emit("add-move",(0,i.pos_to_str)(r,a)),s=!0,this.board.any_moves(-a)&&(a=-a)}return s?(this.turn=a,this.after_move()):this.message({text:this.i18n.invalid_moves,error:!0})}},components:{Disc:u.default}};e.default=d},"89a8":function(t,e,n){"use strict";n.r(e);var r=n("94ff"),o=n.n(r);for(var s in r)"default"!==s&&function(t){n.d(e,t,function(){return r[t]})}(s);e["default"]=o.a},"89c4":function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d");var r={props:["color","will_flip"]};e.default=r},"8fba":function(t,e,n){},"91ea":function(t,e,n){"use strict";n.r(e);var r=n("c285"),o=n("f0a0");for(var s in o)"default"!==s&&function(t){n.d(e,t,function(){return o[t]})}(s);n("6e54");var a=n("2877"),i=Object(a["a"])(o["default"],r["a"],r["b"],!1,null,"06f9648f",null);e["default"]=i.exports},"94ff":function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d");var r={props:["theme","border"],computed:{className:function(){var t;return[this.theme||"dark",null==(t=this.border)||t?"border":null]}}};e.default=r},"9d6c":function(t,e,n){"use strict";var r=n("288e");Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d");var o=r(n("2375")),s=r(n("2a7d")),a=r(n("f4a7")),i={props:["text","pass","back","spin","error"],data:function(){return{i18n:a.default}},components:{Spinner:o.default,Button:s.default}};e.default=i},"9ed8":function(t,e,n){},a321:function(t,e,n){"use strict";var r=n("5c38"),o=n.n(r);o.a},a58c:function(t,e,n){"use strict";var r=n("e39a"),o=n.n(r);o.a},ab69:function(t,e,n){"use strict";var r,o,s,a,i,u,c,l,f,d,v,h,m,p=n("288e"),_=p(n("e814")),b=p(n("75fc"));n("a481");var g=n("fb4e");a=g.UP,r=g.DOWN,o=g.LEFT,s=g.RIGHT,v=g.pos_from_xy,g.Board,m=g.square_to_char;var y=n("f346");d=y.int,h=[{start:v(0,0),major:r,minor:s},{start:v(7,0),major:r,minor:o},{start:v(0,7),major:a,minor:s},{start:v(7,7),major:a,minor:o},{start:v(0,0),major:s,minor:r},{start:v(0,7),major:s,minor:a},{start:v(7,0),major:o,minor:r},{start:v(7,7),major:o,minor:a}],f=function(t){var e,n,r,o,s,a,i,u,c,l,f=arguments.length>1&&void 0!==arguments[1]?arguments[1]:h[0],d=arguments.length>2&&void 0!==arguments[2]?arguments[2]:[Infinity];for(l=f.start,s=f.major,a=f.minor,e=[],c=l,r=0;r<=7;++r){for(u=c,o=0;o<=1;++o){for(n=0,i=0;i<=3;++i)n=3*n+(t.get(u)+1),u+=a;e.push(n+35)}if(c+=s,e>d)return d}return e},i=function(t){return String.fromCharCode.apply(String,(0,b.default)(t)).replace("\\","~")},c=function(t){return i(f(t))},l=function(t){var e,n,r,o,s;for(s=[Infinity],r=0,o=h.length;r<o;r++)n=h[r],e=f(t,n,s),e<s&&(s=e);return i(s)},u=function(t){var e,n,r,o,s;for(e=[],s=function(t,n){return n?(s(d(t/3),n-1),e.push(t%3)):e.push(t)},t=t.replace("~","\\"),r=o=0;o<=15;r=++o)n=t.charCodeAt(r)-35,s(n,3);return e.map(function(t){return m((0,_.default)(t)-1)}).join("")},t.exports={encode:c,encode_normalized:l,decode:u}},b1bb:function(t,e,n){"use strict";var r=n("ec3a"),o=n.n(r);o.a},b253:function(t,e,n){},b823:function(t,e,n){"use strict";n.r(e);var r=n("9d6c"),o=n.n(r);for(var s in r)"default"!==s&&function(t){n.d(e,t,function(){return r[t]})}(s);e["default"]=o.a},bc83:function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("button",{class:t.className,on:{click:function(e){return t.$emit("click")}}},[t._t("default")],2)},o=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return o})},be17:function(t,e,n){"use strict";var r=n("288e");Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0;var o=r(n("f499"));n("cadf"),n("551c"),n("f751"),n("097d");var s=n("fb4e"),a=r(n("357c"));n("d48d");var i,u,c=r(n("576b")),l=r(n("8ca1")),f=r(n("2a7d")),d=r(n("f4a7"));u=function(t,e){return localStorage["uctoth_"+t]=(0,o.default)(e)},i=function(t,e){var n;return n=localStorage["uctoth_"+t],null!=n?JSON.parse(n):e};var v={props:["start"],data:function(){return{levels:["easiest","easy","normal","hard","hardest"],color:i("color",s.BLACK),level:i("level","normal"),guide:i("guide",!0),moves:i("moves",!1),BLACK:s.BLACK,WHITE:s.WHITE,i18n:d.default}},methods:{submit:function(){return u("color",this.color),u("level",this.level),u("guide",this.guide),u("moves",this.moves),this.start(this.color,this.level,this.guide,this.moves)}},components:{Disc:a.default,CheckboxMarked:c.default,CheckboxBlankOutline:l.default,Button:f.default}};e.default=v},c285:function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"box"},[n("div",{staticClass:"label-row"},t._l("ABCDEFGH".split(""),function(e){return n("div",{staticClass:"label"},[t._v(t._s(e))])}),0),t._l(t.rows,function(e,r){return n("div",{staticClass:"row"},[n("div",{staticClass:"label"},[t._v(t._s(r+1))]),t._l(e,function(e){var r=e.disc,o=e.can_move,s=e.is_hover,a=e.will_flip,i=e.move,u=e.enter,c=e.leave;return n("div",{staticClass:"cell",on:{mouseenter:u,mouseleave:c,click:i}},[r?n("transition",{attrs:{name:"flip",mode:"out-in",appear:""}},[n("Disc",{key:r,staticClass:"disc",attrs:{color:r,will_flip:a}})],1):t._e(),t.guide&&o&&!t.hover_at?n("div",{staticClass:"move"}):t._e(),s?n("Disc",{staticClass:"hover",attrs:{color:t.turn==t.BLACK?"black":"white"}}):t._e()],1)}),n("div",{staticClass:"label"},[t._v(t._s(r+1))])],2)}),n("div",{staticClass:"label-row"},t._l("ABCDEFGH".split(""),function(e){return n("div",{staticClass:"label"},[t._v(t._s(e))])}),0)],2)},o=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return o})},c432:function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{attrs:{id:"app"}},["setting"==t.mode?n("h1",[t._v("UCTOTH")]):t._e(),"setting"==t.mode?n("Setting",{staticClass:"setting",attrs:{start:t.start}}):t._e(),"game"==t.mode?n("Game",{attrs:{user:t.color,level:t.level,guide:t.guide,show_moves:t.moves,back:t.back}}):t._e(),t._m(0)],1)},o=[function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"link"},[n("a",{attrs:{href:"https://github.com/ts1/uctoth",target:"_blank"}},[t._v("Source code")])])}];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return o})},cedd:function(t,e,n){},cff9:function(t,e){t.exports="data:audio/mpeg;base64,SUQzBAAAAAAAI1RTU0UAAAAPAAADTGF2ZjU3LjgzLjEwMAAAAAAAAAAAAAAA//tAwAAAAAAAAAAAAAAAAAAAAAAASW5mbwAAAA8AAAADAAADKAB7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3u9vb29vb29vb29vb29vb29vb29vb29vb29vb29vb29vb3///////////////////////////////////////////8AAAAATGF2YzU3LjEwAAAAAAAAAAAAAAAAJAKjAAAAAAAAAyjcTOkNAAAAAAD/+1DEAAAKWKc4NPeAEXkXrvcekAIBPe79/fCcIIEfBziZpckACQAAANA7QBwA4GIb49Y9Z1vjkE3FzLm5tiGIY4MZOC4KCJm8e/vf//+l77xR5EpmlKUp//////R/HPiAMCQ5wQ/4YkiSIIKSUSabbjkkEAAlJ/kR3C6c1fEFmnIE5oefSOjIkxANohUSoFJClQuZvCGJJAm9Um16Pw37DYOSuG7DIR3Nt7t2o+tvEEveW34y93S1ocGnjS8g0FhZSW/1lBa7RIkJNdVnsdw7//tSxAUAC3SZY5zzADFwlWc09g4ZjHQrZ8pGM2EmgQCVHFHkkiCoonJnSWzJHJUclm6jkS2tRVEt/3lohktR0ureWn5+2opZFJ5igMHbip4yLhRpgGgZOjXSI92teCoaKgr2hMjVeLYAAAAAQ3QP6IUhpwXMQmIDsAZBDwiRzmwZwNcGzCH0ax+myckjUDZS4cPGJiWWjI5MXfhd77FxjbnHUMaxiPjHPil7HPdQQE9j5ddyEtouut43vjAXibf/yFbFgAAAAJN38eyZRA3iVDj/+1LEBwGLGKslJ6RywS0Kocg3mHgHeUQcwR1GE2SASYhAYpeSUukaZpSgVJpslZcTLgZQpmXkohZQoVp1S07ONRqxmPKRxm84pcFGv5qCFiQVSEnnT1f+n/6tmv///6RZq4ZmbTlUAKYbAaRIS8m8cRdTFCHF0GMwsKhRTnMWloKicSPCQYpPJhINFioCBkBERKIgdMLAXvypH39KxlPliv/1bMl//yJXS2lMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVQ=="},d341:function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"box"},[n("div",{staticClass:"colors"},[n("div",{staticClass:"color select",class:t.color==t.BLACK&&"is-active",on:{click:function(e){t.color=t.BLACK}}},[n("Disc",{attrs:{color:"black"}}),n("span",[t._v(t._s(t.i18n.first_move))])],1),n("div",{staticClass:"color select",class:t.color==t.WHITE&&"is-active",on:{click:function(e){t.color=t.WHITE}}},[n("Disc",{attrs:{color:"white"}}),n("span",[t._v(t._s(t.i18n.second_move))])],1)]),n("div",{staticClass:"levels"},t._l(t.levels,function(e){return n("div",{staticClass:"level select",class:t.level==e.toLowerCase()&&"is-active",on:{click:function(n){t.level=e.toLowerCase()}}},[t._v(t._s(t.i18n[e]))])}),0),n("div",{staticClass:"guide checkbox select",on:{click:function(e){t.guide=!t.guide}}},[t.guide?n("CheckboxMarked"):t._e(),t.guide?t._e():n("CheckboxBlankOutline"),n("span",{staticClass:"label"},[t._v(t._s(t.i18n.show_guide))])],1),n("div",{staticClass:"moves checkbox select",on:{click:function(e){t.moves=!t.moves}}},[t.moves?n("CheckboxMarked"):t._e(),t.moves?t._e():n("CheckboxBlankOutline"),n("span",{staticClass:"label"},[t._v(t._s(t.i18n.show_moves))])],1),n("div",{staticClass:"langs"},[n("a",{staticClass:"lang select",class:"en"==t.i18n.lang&&"is-active",attrs:{href:"?lang=en"}},[t._v("English")]),n("a",{staticClass:"lang select",class:"ja"==t.i18n.lang&&"is-active",attrs:{href:"?lang=ja"}},[t._v("日本語")])]),n("Button",{on:{click:t.submit}},[t._v(t._s(t.i18n.start))])],1)},o=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return o})},e2ec:function(t,e,n){"use strict";n.r(e);var r=n("eaf8"),o=n.n(r);for(var s in r)"default"!==s&&function(t){n.d(e,t,function(){return r[t]})}(s);e["default"]=o.a},e39a:function(t,e,n){},e5a2:function(t,e,n){t.exports=function(){return new Worker(n.p+"js/worker.0e69f3488f1307a9f310.js")}},eaf8:function(t,e,n){"use strict";var r=n("e54b"),o=n("288e");Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d");var s=o(n("99b8")),a=o(n("c068")),i=o(n("4d77")),u=o(n("91ea")),c=o(n("521f")),l=o(n("2a7d")),f=o(n("f939")),d=o(n("f4a7")),v=r(n("2ba8")),h={props:["user","level","guide","show_moves","back"],data:function(){return{msg:null,msg_key:0,undo_enabled:!1,undo:function(){},muted:v.is_muted(),sound_supported:v.is_supported(),moves:"",entered_moves:"",i18n:d.default}},mounted:function(){return window.scrollTo(0,0)},computed:{level_title:function(){var t;return t=d.default[this.level],d.default.expand("mode",{mode:t})}},methods:{show_message:function(t){return this.msg_key++,this.msg=t},set_undo_btn:function(t,e){return this.undo_enabled=t,this.undo=e},mute:function(){return this.muted=!this.muted,v.mute(this.muted)},add_move:function(t){return this.moves+=t},undo_move:function(){return this.moves=this.moves.substr(0,this.moves.length-2)},enter_moves:function(t){return this.entered_moves=t},reset_moves:function(){return this.moves=""}},components:{BackIcon:s.default,SoundIcon:a.default,MuteIcon:i.default,Board:u.default,MessageBox:c.default,Button:l.default,Moves:f.default}};e.default=h},ec3a:function(t,e,n){},f0a0:function(t,e,n){"use strict";n.r(e);var r=n("85a1"),o=n.n(r);for(var s in r)"default"!==s&&function(t){n.d(e,t,function(){return r[t]})}(s);e["default"]=o.a},f110:function(t,e,n){"use strict";var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",[n("label",[t._v(t._s(t.i18n.moves))]),n("input",{ref:"input",attrs:{spellcheck:"false"},domProps:{value:t.moves},on:{input:function(e){t.moves_=e.target.value},keypress:function(e){return!e.type.indexOf("key")&&t._k(e.keyCode,"enter",13,e.key,"Enter")?null:t.$emit("enter-moves",t.moves_)}}})])},o=[];n.d(e,"a",function(){return r}),n.d(e,"b",function(){return o})},f346:function(t,e,n){"use strict";(function(e){var r=n("288e");n("aef6");var o=r(n("795b"));n("551c");var s=r(n("2d7d"));n("ac6a"),n("cadf"),n("5df3"),n("f400");var a,i,u,c,l,f,d,v,h,m=r(n("75fc"));v=function(t){var e,n,r,o,s;for(t=(0,m.default)(t),r=t.length,e=n=r-1;n>0;e=n+=-1)o=Math.random()*(e+1)|0,s=t[e],t[e]=t[o],t[o]=s;return t},l=function(t){var e;return e=new s.default,function(){for(var n,r=arguments.length,o=new Array(r),s=0;s<r;s++)o[s]=arguments[s];return n=e.get(o),void 0===n&&(n=t.apply(void 0,o),e.set(o)),n}},u=function(t){return 0|t},f=function(t,r){return new o.default(function(o){var s,a;return"-"===t?a=e.stdin:(a=n("3e8f").createReadStream(t),t.endsWith(".gz")&&(a=a.pipe(n("3e8f").createGunzip()))),s=n("3e8f").createInterface(a),s.on("line",function(t){return r(t)}),s.on("close",function(){return o()})})},i=function(t){var r,o;return"-"===t?e.stdout:(o=n("3e8f").createWriteStream(t),t.endsWith(".gz")?(r=n("3e8f").createGzip(),r.pipe(o),r):o)},c=function(t){var e,n,r,o,s,a,i,u;return e={},r={},r.prev=r.next=r,i=0,o=0,a=0,n=0,u=function(t){return t.next.prev=t.prev,t.prev.next=t.next},s=function(t){return t.prev=r,t.next=r.next,r.next.prev=t,r.next=t},{put:function(o,a){var c,l;return c=e[o],c?u(c):i>=t?(n+=1,l=r.prev,u(l),delete e[l.key]):i++,c={key:o,data:a},s(c),e[o]=c},get:function(t){var n;return n=e[t],n?(o+=1,n!==r.next&&(u(n),s(n)),n.data):(a+=1,null)},stats:function(){return{n:i,hit:o,miss:a,evict:n}}}},d=function(t){return Math.round(1e4*t)/1e4},a=1<<30,h=function(t,e){var r,o,s,a,i,u,c,l,f=arguments.length>2&&void 0!==arguments[2]?arguments[2]:null,d=n("ab69");for(s=d.encode_normalized,f||(f=t.list_moves(e)),o={},l=[],i=0,u=f.length;i<u;i++)c=f[i],a=t.move(e,c),r=s(t),t.undo(e,c,a),o[r]||(o[r]=!0,l.push(c));return l},t.exports={shuffle:v,memoize:l,int:u,readlines:f,gzwriter:i,lru_cache:c,round_value:d,INFINITY:a,unique_moves:h}}).call(this,n("4362"))},f4a7:function(t,e,n){"use strict";var r=n("288e");n("a481"),n("7f7f");var o,s,a,i,u,c,l,f=r(n("768b"));n("28a5"),n("386d"),n("cadf"),n("551c"),n("f751"),n("097d"),l={en:{first_move:"First move",second_move:"Second move",show_guide:"Show guide",show_moves:"Show record of moves",start:"Start",undo:"Undo",your_turn:"Your turn.",thinking:"Thinking...",you_pass:"You have no moves.",pass:"Pass",i_pass:"I have no moves. Your turn.",win:"You won by ${discs}!",lose:"You lost by ${discs}!",draw:"Draw!",play_again:"Play Again",easiest:"Very easy",easy:"Easy",normal:"Normal",hard:"Hard",hardest:"Very hard",mode:"${mode} mode",moves:"Moves",invalid_moves:"Incorrect moves."},ja:{first_move:"先手",second_move:"後手",show_guide:"ガイドを表示する",show_moves:"棋譜を表示する",start:"スタート",undo:"待った",your_turn:"あなたの番です。",thinking:"考えています...",you_pass:"あなたの打てるところがありません。",pass:"パス",i_pass:"私の打てるところがありません。あなたの番です。",win:"${discs}であなたの勝ちです!",lose:"${discs}であなたの負けです!",draw:"引き分け!",play_again:"もう一度プレイする",easiest:"超イージー",easy:"イージー",normal:"ノーマル",hard:"ハード",hardest:"超ハード",mode:"${mode}モード",description:"UctothはWebブラウザで遊べるシンプルなオセロ(リバーシ)ゲームです。",moves:"棋譜",invalid_moves:"棋譜に誤りがあります"}},i=function(){var t,e,n,r,o,s,a,i=arguments.length>0&&void 0!==arguments[0]?arguments[0]:window.location.search;for("?"===i[0]&&(i=i.substr(1)),s={},o=i.split("&"),t=0,r=o.length;t<r;t++){n=o[t];var u=n.split("="),c=(0,f.default)(u,2);e=c[0],a=c[1],e=decodeURIComponent(e),a=decodeURIComponent(a),s[e]=a}return s},a=i(),s=a.lang,s?localStorage._oth_lang=a.lang:s=localStorage._oth_lang||(null!=(u=window.navigator.languages)?u[0]:void 0)||window.navigator.language||window.navigator.userLanguage||window.navigator.browserLanguage,l[s]||(s="en"),c=l[s],"en"!==s&&(document.querySelector("html").setAttribute("lang",s),document.querySelector('meta[name="description"]').setAttribute("content",c.description)),o=function(t,e){var n;if(n=c[t],!n)throw new Error("no translation");return n.replace(/\$\{(\w+)\}/g,function(t,n){return e[n]})},t.exports=c,t.exports.lang=s,t.exports.expand=o},f571:function(t,e,n){"use strict";n.r(e);var r=n("be17"),o=n.n(r);for(var s in r)"default"!==s&&function(t){n.d(e,t,function(){return r[t]})}(s);e["default"]=o.a},f939:function(t,e,n){"use strict";n.r(e);var r=n("f110"),o=n("6965");for(var s in o)"default"!==s&&function(t){n.d(e,t,function(){return o[t]})}(s);n("2691");var a=n("2877"),i=Object(a["a"])(o["default"],r["a"],r["b"],!1,null,"0a34d322",null);e["default"]=i.exports},fb4e:function(t,e,n){"use strict";var r=n("288e"),o=r(n("f499"));n("ac6a"),n("28a5");var s=r(n("75fc")),a=r(n("d225")),i=r(n("b0b4")),u=r(n("2d7d"));n("cadf"),n("5df3"),n("f400");var c,l,f,d,v,h,m,p,_,b,g,y,A,k,w,x,C,E,j,S,B,V,M=r(n("e814"));n("551c"),n("f751"),n("097d");var I=n("f346");w=I.int,v=0,l=1,g=-1,m=2,j=function(t,e){return 9*(e+1)+(t+1)},E=function(t){var e,n;if(e=t.toLowerCase().charCodeAt(0)-"a".charCodeAt(0),n=(0,M.default)(t[1])-1,e<0||e>7||n<0||n>7)throw new Error("invalid position string");return j(e,n)},B=function(t){return{x:t%9-1,y:w(t/9)-1}},S=function(t){var e,n,r,o=arguments.length>1&&void 0!==arguments[1]?arguments[1]:l,s=B(t);return n=s.x,r=s.y,e=o===l?"A":"a",String.fromCharCode(e.charCodeAt(0)+n)+(r+1)},x=function(t){var e,n,r;n=/([a-hA-H][1-8])/g,r=[];while(1){if(e=n.exec(t),!e)break;r.push(E(e[0]))}return r},C=function(t){var e,n;return n=function(){var n,r,o;for(o=[],n=0,r=t.length;n<r;n++)e=t[n],null!=e.move&&null!=e.turn?o.push(S(e.move,e.turn)):o.push(S(e));return o}(),n.join("")},A={"-":v,X:l,O:g},k=function(t){return A[t]},V=function(){var t,e,n;return e=new u.default(function(){var e;for(t in e=[],A)n=A[t],e.push([n,t]);return e}()),function(t){return e.get(t)||"?"}}(),c=function(){var t,e,n,r,o;for(n=[],o=t=0;t<=7;o=++t)for(r=e=0;e<=7;r=++e)n.push(j(r,o));return n}(),y=[],y[E("B2")]=!0,y[E("G2")]=!0,y[E("B7")]=!0,y[E("G7")]=!0,b=-9,d=9,p=-1,_=1,h=function(){var t,e,n,r,o,s;for(r=[],s=e=0;e<=7;s=++e)for(o=n=0;n<=7;o=++n)r[j(o,s)]=t=[],o>1&&(t.push(p),s>1&&t.push(p+b),s<6&&t.push(p+d)),o<6&&(t.push(_),s>1&&t.push(_+b),s<6&&t.push(_+d)),s>1&&t.push(b),s<6&&t.push(d);return r}(),function(){var t,e,n,r,o,s,a,i;for(t=["A1","C1","A3","D1","A4","C3","D3","C4","D2","B4","B1","A2","C2","B3","B2","D4"],r=[],e=0,n=t.length;e<n;e++){s=t[e],o=E(s);var u=B(o);a=u.x,i=u.y,r.push(j(a,i)),r.push(j(7-a,i)),r.push(j(a,7-i)),r.push(j(7-a,7-i))}}(),f=function(){function t(e){(0,a.default)(this,t),e?"string"===typeof e?this.load(e):(this.board=(0,s.default)(e.board),this.build_empty_list()):this.load("- - - - - - - -\n- - - - - - - -\n- - - - - - - -\n- - - O X - - -\n- - - X O - - -\n- - - - - - - -\n- - - - - - - -\n- - - - - - - -")}return(0,i.default)(t,[{key:"load",value:function(t){var e,n,r,o,s,a,i,u,c;for(e=m,r=v,this.board=[e,e,e,e,e,e,e,e,e,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,r,r,r,r,r,r,r,r,e,e,e,e,e,e,e,e,e,e],u=0,c=0,a=t.split(""),o=0,s=a.length;o<s;o++)if(n=a[o],i=k(n),"undefined"!==typeof i){if(c>=8)throw new Error("too many cells");this.board[j(u,c)]=i,++u>=8&&(u=0,c++)}if(c<8)throw new Error("too few cells");return this.build_empty_list()}},{key:"dump",value:function(){var t,e,n,r,o,s,a,i=arguments.length>0&&void 0!==arguments[0]&&arguments[0];if(r=[],i){for(r.push(" "),s=t=0;t<=7;s=++t)r.push(" "),r.push(String.fromCharCode("A".charCodeAt(0)+s));r.push("\n")}for(a=e=0;e<=7;a=++e){for(i&&(r.push(a+1),r.push(" ")),s=n=0;n<=7;s=++n)r.push(V(this.board[j(s,a)])||"?"),i&&r.push(" ");i&&r.push(a+1),i&&r.push("\n")}if(i)for(r.push(" "),s=o=0;o<=7;s=++o)r.push(" "),r.push(String.fromCharCode("A".charCodeAt(0)+s));return r.join("")}},{key:"get",value:function(t){return this.board[t]}},{key:"count",value:function(t){var e,n=this;return e=0,c.forEach(function(r){if(n.board[r]===t)return e++}),e}},{key:"can_move",value:function(t,e){var n,r,o,s,a,i;if(this.board[e]===v)for(r=-t,i=h[e],o=0,s=i.length;o<s;o++)if(n=i[o],a=e+n,this.board[a]===r){a+=n;while(this.board[a]===r)a+=n;if(this.board[a]===t)return!0}return!1}},{key:"any_moves",value:function(t){var e,n=this;return e=!1,this.each_empty(function(r){if(n.can_move(t,r))return e=!0,!1}),e}},{key:"count_moves",value:function(t){var e,n=this;return e=0,this.each_empty(function(r){if(n.can_move(t,r))return e++}),e}},{key:"list_moves",value:function(t){var e,n=this;return e=[],this.each_empty(function(r){if(n.can_move(t,r))return e.push(r)}),e}},{key:"list_moves_but_x",value:function(t){var e,n=this;return e=[],this.each_empty(function(r){if(!y[r]&&n.can_move(t,r))return e.push(r)}),e}},{key:"move",value:function(t,e){var n,r,o,s,a,i,u,c=!(arguments.length>2&&void 0!==arguments[2])||arguments[2];if(r=[],this.board[e]===v){for(o=-t,u=h[e],s=0,a=u.length;s<a;s++)if(n=u[s],i=e+n,this.board[i]===o){i+=n;while(this.board[i]===o)i+=n;if(this.board[i]===t)while((i-=n)!==e)this.board[i]=t,r.push(i)}r.length&&(this.board[e]=t,c&&this.pop_empty_list(e))}return r}},{key:"count_flips",value:function(t,e){var n,r,o,s,a,i,u,c;if(r=0,this.board[e]===v)for(o=-t,c=h[e],s=0,a=c.length;s<a;s++){n=c[s],u=e+n,i=0;while(this.board[u]===o)u+=n,i++;this.board[u]===t&&(r+=i)}return r}},{key:"undo",value:function(t,e,n){var r,o,s,a,i=!(arguments.length>3&&void 0!==arguments[3])||arguments[3];for(r=-t,o=0,s=n.length;o<s;o++)a=n[o],this.board[a]=r;if(this.board[e]=v,i)return this.push_empty_list(e)}},{key:"score",value:function(t){var e,n,r=this;return e=-t,n=0,c.forEach(function(o){switch(r.board[o]){case t:return n++;case e:return n--}}),n}},{key:"outcome",value:function(){var t,e,n,r=this,o=arguments.length>0&&void 0!==arguments[0]?arguments[0]:l;return e=-o,n=0,t=0,c.forEach(function(s){switch(r.board[s]){case o:return n++;case e:return n--;case v:return t++}}),t&&(n>0?n+=t:n<0&&(n-=t)),n}},{key:"build_empty_list",value:function(){var t,e=this;return this.empty_next=[0],this.empty_prev=[0],t=0,c.forEach(function(n){if(e.board[n]===v)return e.empty_next[t]=n,e.empty_prev[n]=t,t=n}),this.empty_next[t]=0}},{key:"pop_empty_list",value:function(t){return this.empty_next[this.empty_prev[t]]=this.empty_next[t],this.empty_prev[this.empty_next[t]]=this.empty_prev[t]}},{key:"push_empty_list",value:function(t){return this.empty_next[this.empty_prev[t]]=t,this.empty_prev[this.empty_next[t]]=t}},{key:"first_empty",value:function(){return this.empty_next[0]}},{key:"each_empty",value:function(t){var e,n;e=0,n=[];while(1){if(e=this.empty_next[e],0===e)break;if(!1===t(e))break;n.push(void 0)}return n}},{key:"validate_empty_list",value:function(){var t,e,n=this;return e=0,this.each_empty(function(t){return console.assert(n.board[t]===v),e++}),t=0,c.forEach(function(e){if(n.board[e]===v)return t++}),console.assert(e===t)}},{key:"key",value:function(){return(0,o.default)(this.board)}}]),t}(),t.exports={EMPTY:v,BLACK:l,WHITE:g,GUARD:m,ALL_POSITIONS:c,UP:b,DOWN:d,LEFT:p,RIGHT:_,pos_from_xy:j,pos_from_str:E,pos_to_xy:B,pos_to_str:S,pos_array_from_str:x,pos_array_to_str:C,square_to_char:V,char_to_square:k,Board:f}}});
//# sourceMappingURL=app.ad314bff.js.map