(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-common"],{"0130":function(e,t,n){"use strict";n.r(t);var r=n("89c4"),o=n.n(r);for(var s in r)"default"!==s&&function(e){n.d(t,e,function(){return r[e]})}(s);t["default"]=o.a},"03cd":function(e,t,n){},"1fb2":function(e,t,n){"use strict";n("cadf"),n("551c"),n("f751"),n("097d"),e.exports={props:{moves:{required:!0}},data:function(){return{i18n:n("f4a7")}},watch:{moves:function(){var e=this;return this.$nextTick(function(){return e.$refs.input.scrollLeft=9999})}}}},2375:function(e,t,n){"use strict";n.r(t);var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("svg",{staticClass:"spinner",attrs:{viewBox:"0 0 100 100"}},[n("circle",{attrs:{cx:"50",cy:"50",fill:"none",stroke:"currentColor","stroke-width":"7",r:"35","stroke-dasharray":"200 20"}})])},o=[],s=(n("3e51"),n("2877")),i={},a=Object(s["a"])(i,r,o,!1,null,"2aca0085",null);t["default"]=a.exports},2466:function(e,t,n){"use strict";var r;n("cadf"),n("551c"),n("f751"),n("097d"),r=document.body,window.addEventListener("touchmove",function(e){if(r.scrollHeight<=window.innerHeight)return e.preventDefault()},{passive:!1})},"25e0":function(e,t,n){"use strict";n.r(t);var r=n("6e49"),o=n("e2ec");for(var s in o)"default"!==s&&function(e){n.d(t,e,function(){return o[e]})}(s);n("5a17");var i=n("2877"),a=Object(i["a"])(o["default"],r["a"],r["b"],!1,null,"3a2f1237",null);t["default"]=a.exports},2732:function(e,t,n){e.exports=n.p+"media/undo.7c95aa38.mp3"},"27c5":function(e,t,n){"use strict";n.r(t);var r=n("6adc"),o=n("f571");for(var s in o)"default"!==s&&function(e){n.d(t,e,function(){return o[e]})}(s);n("9859");var i=n("2877"),a=Object(i["a"])(o["default"],r["a"],r["b"],!1,null,"8d2581be",null);t["default"]=a.exports},"2a7d":function(e,t,n){"use strict";n.r(t);var r=n("b04e"),o=n("89a8");for(var s in o)"default"!==s&&function(e){n.d(t,e,function(){return o[e]})}(s);n("e6e0");var i=n("2877"),a=Object(i["a"])(o["default"],r["a"],r["b"],!1,null,"3d0e4a62",null);t["default"]=a.exports},"2a90":function(e,t,n){"use strict";var r=n("288e");Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d"),n("494d");var o,s=r(n("27c5")),i=r(n("25e0"));o=function(){var e;return e=document.documentElement.clientHeight,document.documentElement.style.setProperty("--win-height","".concat(e,"px"))};var a={name:"app",data:function(){return{mode:"setting",color:null,level:null,guide:null,moves:null}},methods:{start:function(e,t,n,r){return this.color=e,this.level=t,this.guide=n,this.moves=r,this.mode="game"},back:function(){return this.mode="setting"}},components:{Setting:s.default,Game:i.default},mounted:function(){var e,t;if(null!=(null!=(e=document.documentElement)&&null!=(t=e.style)?t.setProperty:void 0))return window.addEventListener("resize",o,{passive:!0}),this.$nextTick(o)},beforeDestroy:window.removeEventListener("resize",o)};t.default=a},"2ba8":function(e,t,n){"use strict";var r=n("288e");Object.defineProperty(t,"__esModule",{value:!0}),t.default=h,t.mute=t.is_muted=t.is_supported=void 0,n("7f7f"),n("96cf");var o=r(n("3b8d")),s=r(n("795b"));n("551c"),n("cadf"),n("f751"),n("097d");var i,a,u,c,l,f,d,v=n("ce0b");function h(e){return m.apply(this,arguments)}function m(){return m=(0,o.default)(regeneratorRuntime.mark(function e(t){var n,r;return regeneratorRuntime.wrap(function(e){while(1)switch(e.prev=e.next){case 0:if(!l){e.next=2;break}return e.abrupt("return");case 2:if(!a){e.next=15;break}if(n=d[t],n){e.next=6;break}throw new Error("sound ".concat(t," is not loaded"));case 6:return r=a.createBufferSource(),r.loop=!1,e.next=10,n;case 10:return r.buffer=e.sent,r.connect(a.destination),e.abrupt("return",r.start(0));case 15:return e.abrupt("return",d[t].play());case 16:case"end":return e.stop()}},e)})),m.apply(this,arguments)}d={},a=null,l=(0,v.get_pref)("mute",!1),i=window.AudioContext||window.webkitAudioContext,c=function(e){return d.move=e(n("cff9")),d.alert=e(n("722c")),d.undo=e(n("2732"))},null!=(null!=i&&null!=(f=i.prototype)?f.resume:void 0)?(u=function(){if(!a)return a=new i,a.resume(),c(function(e){return new s.default(function(t,n){var r;return r=new XMLHttpRequest,r.open("GET",e),r.responseType="arraybuffer",r.onload=function(){return 200===r.status?a.decodeAudioData(r.response,function(e){return t(e)}):(console.dir(r),n(new Error("error loading ".concat(e))))},r.send()})}),window.removeEventListener("click",u)},window.addEventListener("click",u)):c(function(e){var t;return t=document.createElement("audio"),t.src=e,t.preload="auto",document.body.appendChild(t),t});var p=function(){return!0};t.is_supported=p;var _=function(){return l};t.is_muted=_;var A=function(e){return l=e,(0,v.set_pref)("mute",e)};t.mute=A},"357c":function(e,t,n){"use strict";n.r(t);var r=n("d8f6"),o=n("0130");for(var s in o)"default"!==s&&function(e){n.d(t,e,function(){return o[e]})}(s);n("3a4c");var i=n("2877"),a=Object(i["a"])(o["default"],r["a"],r["b"],!1,null,"bab0418e",null);t["default"]=a.exports},"390c":function(e,t,n){},"3a4c":function(e,t,n){"use strict";var r=n("db47"),o=n.n(r);o.a},"3dfd":function(e,t,n){"use strict";var r=n("8107"),o=n("6593"),s=(n("7faf"),n("2877")),i=Object(s["a"])(o["default"],r["a"],r["b"],!1,null,null,null);t["default"]=i.exports},"3e51":function(e,t,n){"use strict";var r=n("03cd"),o=n.n(r);o.a},"3e75":function(e,t,n){},"521f":function(e,t,n){"use strict";n.r(t);var r=n("a6a3"),o=n("b823");for(var s in o)"default"!==s&&function(e){n.d(t,e,function(){return o[e]})}(s);n("6b1e");var i=n("2877"),a=Object(i["a"])(o["default"],r["a"],r["b"],!1,null,"06331f7e",null);t["default"]=a.exports},5482:function(e,t,n){"use strict";var r=n("924f"),o=n.n(r);o.a},"56d7":function(e,t,n){"use strict";n.r(t);n("cadf"),n("551c"),n("f751"),n("097d");var r=n("2b0e"),o=n("3dfd"),s=(n("2466"),n("9483"));Object(s["a"])("".concat("","service-worker.js"),{ready:function(){console.log("App is being served from cache by a service worker.\nFor more details, visit https://goo.gl/AFskqB")},registered:function(){console.log("Service worker has been registered.")},cached:function(){console.log("Content has been cached for offline use.")},updatefound:function(){console.log("New content is downloading.")},updated:function(){console.log("New content is available; please refresh.")},offline:function(){console.log("No internet connection found. App is running in offline mode.")},error:function(e){console.error("Error during service worker registration:",e)}}),r["a"].config.productionTip=!1,new r["a"]({render:function(e){return e(o["default"])}}).$mount("#app")},"5a17":function(e,t,n){"use strict";var r=n("a7c2"),o=n.n(r);o.a},"5cf2":function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",[n("label",[e._v(e._s(e.i18n.t.moves))]),n("input",{ref:"input",attrs:{spellcheck:"false"},domProps:{value:e.moves},on:{keypress:function(t){return!t.type.indexOf("key")&&e._k(t.keyCode,"enter",13,t.key,"Enter")?null:e.$emit("enter-moves",t.target.value)}}})])},o=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return o})},"63c5":function(e,t,n){},6593:function(e,t,n){"use strict";var r=n("2a90"),o=n.n(r);t["default"]=o.a},6965:function(e,t,n){"use strict";n.r(t);var r=n("1fb2"),o=n.n(r);for(var s in r)"default"!==s&&function(e){n.d(t,e,function(){return r[e]})}(s);t["default"]=o.a},"6adc":function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"box"},[n("div",{staticClass:"colors"},[n("div",{staticClass:"color select",class:e.color==e.BLACK&&"is-active",on:{click:function(t){e.color=e.BLACK}}},[n("Disc",{attrs:{color:"black"}}),n("span",[e._v(e._s(e.i18n.t.first_move))])],1),n("div",{staticClass:"color select",class:e.color==e.WHITE&&"is-active",on:{click:function(t){e.color=e.WHITE}}},[n("Disc",{attrs:{color:"white"}}),n("span",[e._v(e._s(e.i18n.t.second_move))])],1)]),n("div",{staticClass:"levels"},e._l(e.levels,function(t){return n("div",{staticClass:"level select",class:e.level==t.toLowerCase()&&"is-active",on:{click:function(n){e.level=t.toLowerCase()}}},[e._v(e._s(e.i18n.t[t]))])}),0),n("div",{staticClass:"guide checkbox select",on:{click:function(t){e.guide=!e.guide}}},[e.guide?n("CheckboxMarked"):e._e(),e.guide?e._e():n("CheckboxBlankOutline"),n("span",{staticClass:"label"},[e._v(e._s(e.i18n.t.show_guide))])],1),n("div",{staticClass:"moves checkbox select",on:{click:function(t){e.moves=!e.moves}}},[e.moves?n("CheckboxMarked"):e._e(),e.moves?e._e():n("CheckboxBlankOutline"),n("span",{staticClass:"label"},[e._v(e._s(e.i18n.t.show_moves))])],1),n("div",{staticClass:"langs"},[n("div",{staticClass:"lang select",class:"en"==e.i18n.lang&&"is-active",on:{click:function(t){return e.i18n.set("en")}}},[e._v("English")]),n("div",{staticClass:"lang select",class:"ja"==e.i18n.lang&&"is-active",on:{click:function(t){return e.i18n.set("ja")}}},[e._v("日本語")])]),n("Button",{on:{click:e.submit}},[e._v(e._s(e.i18n.t.start))])],1)},o=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return o})},"6b1e":function(e,t,n){"use strict";var r=n("63c5"),o=n.n(r);o.a},"6e49":function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"screen"},[n("header",[n("div",{staticClass:"icons"},[n("Button",{attrs:{border:!1},on:{click:e.back}},[n("BackIcon")],1),e.sound_supported?n("Button",{attrs:{border:!1},on:{click:e.mute}},[e.muted?e._e():n("SoundIcon"),e.muted?n("MuteIcon"):e._e()],1):e._e()],1),n("div",{staticClass:"level"},[e._v(e._s(e.level_title))]),n("Button",{staticClass:"undo",attrs:{disabled:!e.undo_enabled},on:{click:e.undo}},[e._v(e._s(e.i18n.t.undo))])],1),n("main",[n("Board",{staticClass:"board",attrs:{user:e.user,level:e.level,guide:e.guide,message:e.show_message,back:e.back,set_undo_btn:e.set_undo_btn,entered_moves:e.entered_moves},on:{"add-move":function(t){return e.add_move(t)},undo:e.undo_move,"reset-moves":e.reset_moves}}),e.show_moves?n("Moves",{staticClass:"moves",attrs:{moves:e.moves},on:{"enter-moves":function(t){return e.enter_moves(t)}}}):e._e(),n("div",{staticClass:"msg-box-wrapper"},[n("transition",{attrs:{name:"msg"}},[e.msg?n("MessageBox",e._b({key:e.msg_key,staticClass:"msg-box"},"MessageBox",e.msg,!1)):e._e()],1)],1)],1),n("div",{staticClass:"filler"})])},o=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return o})},"722c":function(e,t){e.exports="data:audio/mpeg;base64,SUQzBAAAAAAAI1RTU0UAAAAPAAADTGF2ZjU3LjgzLjEwMAAAAAAAAAAAAAAA//tAwAAAAAAAAAAAAAAAAAAAAAAASW5mbwAAAA8AAAAFAAAEygBRUVFRUVFRUVFRUVFRUVFRUVFRfX19fX19fX19fX19fX19fX19fX2oqKioqKioqKioqKioqKioqKioqNTU1NTU1NTU1NTU1NTU1NTU1NTU//////////////////////////8AAAAATGF2YzU3LjEwAAAAAAAAAAAAAAAAJAUKAAAAAAAABMqKhV9EAAAAAAD/+1DEAAAKLF0qVYeAAX0VqR8w8AEAHALJmEJZtWNQwxMOVDkwMJImZgkJlKAjpXxJORAIAKwFsFWGrDVg5wc442IW8XMy3PFNMaHk4LgdDJEpSlI4fEBwQA+D4PjwcBAMf8H//f0AAAyOPf8AAAAJ2gMS5ESiQjfBU6lo4x7hCFfAgUkmHRSVRHVnIcbqOIBOtkGTmGZOyMqqkTS/37jWearZPOd0NsitXaW7w/Gk3rMeD8W1jPx7RZdX1es2N3rCk2TJN5ICEZjElj5mBIri//tSxAUDi1yXKD2pgBFxkeOBvLXgqqYAmdgccMwYAGglS9MxWOeSCATvpehaaAfYaRGiFQHbCpCKlUuBakETFsZCbgWGpJQ5QeNqyZFFSWiXRmT+kQ42ekUvOPzp7rPZ6W215LfS8RKDnBN5a18HTFAQ2GqMDAnEbErIZjSGHgzhv41swhnDgreFOIIw1mHJ68wEI5lmeENorV9aj66MdbuLWyqUG0bcayk2ZHtycf6yjiHdK7PbU/9P//////juZJLqAIAEMkIA5+YSBP6+yMr/+1LEBwILTJkWrTzygWO1YoWVipExzIoLIE1lShCMmuNnkEXADMiGQfepxQaJOaSeZhsC4wvY7QOMX5oYNP5Sw1qoXLcIW6luUf26F9eer2ez6P////7dVE8YvAyBqQSELBUzMTS1VDPUUjB1qV77v6+IM5EmabHJI0mFnuZr5HicO2mfKfv8koIGPcAlfKgI18WZX8ILcG3R+n/v/r//6P69/69H07f/6////v9sv9qmvdZ7lOfaKbkqAHUU0Y0wqaD+ZzANY/X2L6GL92O6jv/7UsQLAgplpRbMLFKJYjYhgPSWATFe83KV+/zKgav0g2vhUE2veTfgXQN6/+969P3/q3/X9OrJ7X9VKzL9P7Zfr+//X7372/qz3QxKO6g3L83HZA/S8Q52QNkZik2zhtB6ZMxyBE1j00uBO5KHlcg1ugt5n5W6///5fR0f//+ZaGr/vs6fVq72meqei/Z///5epsyLUlnFYiyDVETMFsVg8JC4wTINBQ6UbWrpgFEJjSREo9DEjTExpI0CKTVQs3JPWSo8f4/hIfpbrT/8i17W//tSxBMDxyws/EMYwAAAADSAAAAEsdxUy34sPyLv/x/5EOhICkbaAqpMQU1FMy4xMDCqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqo="},"7faf":function(e,t,n){"use strict";var r=n("8fba"),o=n.n(r);o.a},8107:function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{attrs:{id:"app"}},["setting"==e.mode?n("h1",[e._v("UCTOTH")]):e._e(),"setting"==e.mode?n("Setting",{staticClass:"setting",attrs:{start:e.start}}):e._e(),"game"==e.mode?n("Game",{attrs:{user:e.color,level:e.level,guide:e.guide,show_moves:e.moves,back:e.back}}):e._e(),e._m(0)],1)},o=[function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"link"},[n("a",{attrs:{href:"https://github.com/ts1/uctoth",target:"_blank"}},[e._v("Source code")])])}];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return o})},"85a1":function(e,t,n){"use strict";var r=n("288e");Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf");var o=r(n("768b")),s=r(n("0a0d"));n("ac6a"),n("551c"),n("f751"),n("097d");var i,a=n("fb4e"),u=r(n("357c")),c=r(n("e5a2")),l=r(n("f4a7")),f=r(n("2ba8"));i=new c.default;var d={props:["user","level","guide","message","back","set_undo_btn","entered_moves"],data:function(){return{board:new a.Board,turn:a.BLACK,flips:[],hover_at:null,undo_stack:[],thinking:!1,user_moves:0,gameover:!1,will_flip_enabled:!1,keys:[],BLACK:a.BLACK,i18n:l.default}},mounted:function(){var e=this;return i.postMessage({type:"set_level",level:this.level}),this.proceed(),gtag("event","start",{event_category:"game",event_label:this.level}),this.key_listener=function(t){return e.keypress(t)},window.addEventListener("keypress",this.key_listener)},beforeDestroy:function(){return window.removeEventListener("keypress",this.key_listener)},updated:function(){return this.$el.classList.add("animate")},computed:{can_undo:function(){return!this.thinking&&this.user_moves&&!this.gameover},rows:function(){var e,t,n,r=this;return t=function(){var t,r,o=this;for(r=[],n=t=0;t<8;n=++t)e=[],[0,1,2,3,4,5,6,7].forEach(function(t){var r,s;return s=(0,a.pos_from_xy)(t,n),r=o.board.get(s),e.push({disc:r===a.BLACK?"black":r===a.WHITE?"white":null,can_move:o.turn===o.user&&o.board.can_move(o.turn,s),is_hover:o.turn===o.user&&(o.hover_at===s&&o.board.can_move(o.turn,s)),will_flip:o.will_flip_enabled&&o.flips.indexOf(s)>=0,move:function(){if(o.turn===o.user)return o.move(s)},enter:function(){if(o.turn===o.user)return o.flips=o.board.move(o.turn,s),o.flips.length&&(o.board.undo(o.turn,s,o.flips),o.hover_at=s),o.will_flip_enabled=!1},leave:function(){return o.hover_at=null,o.flips=[],o.will_flip_enabled=!1}})}),r.push(e);return r}.call(this),setTimeout(function(){return r.will_flip_enabled=!0},50),t}},methods:{move:function(e){var t,n=arguments.length>1&&void 0!==arguments[1]&&arguments[1];return this.flips=[],this.hover_at=null,t=this.board.move(this.turn,e),!!t.length&&(n||(0,f.default)("move"),this.$emit("add-move",(0,a.pos_to_str)(e,this.turn)),this.undo_stack.push([this.turn,e,t]),this.turn===this.user&&this.user_moves++,this.turn=-this.turn,n||this.proceed(),!0)},proceed:function(){var e,t,n=this;return this.board.any_moves(this.turn)?this.turn===this.user?this.message({text:this.i18n.t.your_turn}):this.worker_move():(this.turn=-this.turn,this.board.any_moves(this.turn)?this.turn===this.user?this.message({text:this.i18n.t.i_pass}):this.message({text:this.i18n.t.you_pass,pass:function(){return n.worker_move()}}):(this.gameover=!0,t=this.board.outcome(this.user),e="".concat(this.board.count(this.user),":").concat(this.board.count(-this.user)),t>0?(this.message({text:l.default.expand("win",{discs:e}),back:this.back}),gtag("event","win",{event_category:"game",event_label:this.level,value:t})):t<0?(this.message({text:l.default.expand("lose",{discs:e}),back:this.back}),gtag("event","lose",{event_category:"game",event_label:this.level,value:t})):(this.message({text:this.i18n.t.draw,back:this.back}),gtag("event","draw",{event_category:"game",event_label:this.level,value:t}))))},worker_move:function(){var e,t=this;return this.message({text:this.i18n.t.thinking,spin:!0}),e=(0,s.default)(),i.onmessage=function(n){var r,o;i.onmessage=null,e=(0,s.default)()-e,console.log("".concat(e," msec"));var u=n.data;return r=u.move,o=u.value,console.log("Move",(0,a.pos_to_str)(r)),null!=o&&console.log("Estimated value",Math.round(100*o)/100),setTimeout(function(){return t.move(r),t.thinking=!1},e<2e3?2e3-e:0)},this.thinking=!0,i.postMessage({type:"move",board:this.board.dump(),turn:this.turn})},undo:function(){var e,t,n;if(!this.can_undo)throw new Error("cannot undo");while(1){var r=this.undo_stack.pop(),s=(0,o.default)(r,3);if(n=s[0],t=s[1],e=s[2],this.board.undo(n,t,e),this.$emit("undo"),n===this.user)break}return this.user_moves--,this.turn!==this.user&&(this.turn=this.user,this.message({text:this.i18n.t.your_turn})),(0,f.default)("undo"),this.board.board.push(0),this.board.board.pop()},keypress:function(e){var t,n;if("INPUT"!==e.target.nodeName){if("u"!==e.key){this.keys.push(e.key),this.keys=this.keys.slice(-2),n=this.keys.join("");try{t=(0,a.pos_from_str)(n)}catch(r){t=0}return t?this.turn===this.user&&this.board.can_move(this.user,t)?this.move(t):(0,f.default)("alert"):void 0}this.can_undo?this.undo():(0,f.default)("alert")}}},watch:{can_undo:function(){return this.set_undo_btn(this.can_undo,this.undo)},entered_moves:function(){var e,t,n,r,o,s=this;for(this.undo_stack=[],this.user_moves=0,this.$emit("reset-moves"),this.board=new a.Board,o=!0,this.turn=a.BLACK,this.gameover=!1,r=(0,a.pos_array_from_str)(this.entered_moves),e=0,t=r.length;e<t;e++){if(n=r[e],!this.move(n,!0)){o=!1;break}this.board.any_moves(this.turn)||(this.turn=-this.turn)}return o?this.proceed():(this.message({text:this.i18n.t.invalid_moves,error:!0}),(0,f.default)("alert"),setTimeout(function(){return s.proceed()},2e3))}},components:{Disc:u.default}};t.default=d},"89a8":function(e,t,n){"use strict";n.r(t);var r=n("94ff"),o=n.n(r);for(var s in r)"default"!==s&&function(e){n.d(t,e,function(){return r[e]})}(s);t["default"]=o.a},"89c4":function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d");var r={props:["color","will_flip"]};t.default=r},"8fba":function(e,t,n){},"91ea":function(e,t,n){"use strict";n.r(t);var r=n("a5e6"),o=n("f0a0");for(var s in o)"default"!==s&&function(e){n.d(t,e,function(){return o[e]})}(s);n("d72e");var i=n("2877"),a=Object(i["a"])(o["default"],r["a"],r["b"],!1,null,"f1952cb4",null);t["default"]=a.exports},"924f":function(e,t,n){},"94ff":function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d");var r={props:["theme","border"],computed:{className:function(){var e;return[this.theme||"dark",null==(e=this.border)||e?"border":null]}}};t.default=r},9859:function(e,t,n){"use strict";var r=n("a0da"),o=n.n(r);o.a},"9d6c":function(e,t,n){"use strict";var r=n("288e");Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d");var o=r(n("2375")),s=r(n("2a7d")),i=r(n("f4a7")),a={props:["text","pass","back","spin","error"],data:function(){return{i18n:i.default}},components:{Spinner:o.default,Button:s.default}};t.default=a},a0da:function(e,t,n){},a5e6:function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"box"},[n("div",{staticClass:"label-row"},e._l("ABCDEFGH".split(""),function(t){return n("div",{staticClass:"label"},[e._v(e._s(t))])}),0),e._l(e.rows,function(t,r){return n("div",{staticClass:"row"},[n("div",{staticClass:"label"},[e._v(e._s(r+1))]),e._l(t,function(t){var r=t.disc,o=t.can_move,s=t.is_hover,i=t.will_flip,a=t.move,u=t.enter,c=t.leave;return n("div",{staticClass:"cell",on:{mouseenter:u,mouseleave:c,click:a}},[r?n("transition",{attrs:{name:"flip",mode:"out-in",appear:""}},[n("Disc",{key:r,staticClass:"disc",attrs:{color:r,will_flip:i}})],1):e._e(),e.guide&&o&&!e.hover_at?n("div",{staticClass:"move"}):e._e(),s?n("Disc",{staticClass:"hover",attrs:{color:e.turn==e.BLACK?"black":"white"}}):e._e()],1)}),n("div",{staticClass:"label"},[e._v(e._s(r+1))])],2)}),n("div",{staticClass:"label-row"},e._l("ABCDEFGH".split(""),function(t){return n("div",{staticClass:"label"},[e._v(e._s(t))])}),0)],2)},o=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return o})},a6a3:function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"box",class:e.error&&"error"},[n("div",{staticClass:"text"},[e.spin?n("Spinner",{staticClass:"spinner"}):e._e(),e._v(e._s(e.text))],1),e.pass||e.back?n("div",{staticClass:"action"},[e.pass?n("Button",{attrs:{theme:"light"},on:{click:e.pass}},[e._v(e._s(e.i18n.t.pass))]):e._e(),e.back?n("Button",{attrs:{theme:"light"},on:{click:e.back}},[e._v(e._s(e.i18n.t.play_again))]):e._e()],1):e._e()])},o=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return o})},a7c2:function(e,t,n){},ab69:function(e,t,n){"use strict";var r,o,s,i,a,u,c,l,f,d,v,h,m,p=n("288e"),_=p(n("e814")),A=p(n("75fc"));n("a481"),n("cadf"),n("551c"),n("f751"),n("097d");var b=n("fb4e");i=b.UP,r=b.DOWN,o=b.LEFT,s=b.RIGHT,v=b.pos_from_xy,b.Board,m=b.square_to_char;var q=n("f346");d=q.int,h=[{start:v(0,0),major:r,minor:s},{start:v(7,0),major:r,minor:o},{start:v(0,7),major:i,minor:s},{start:v(7,7),major:i,minor:o},{start:v(0,0),major:s,minor:r},{start:v(0,7),major:s,minor:i},{start:v(7,0),major:o,minor:r},{start:v(7,7),major:o,minor:i}],f=function(e){var t,n,r,o,s,i,a,u,c,l,f=arguments.length>1&&void 0!==arguments[1]?arguments[1]:h[0],d=arguments.length>2&&void 0!==arguments[2]?arguments[2]:[Infinity];for(l=f.start,s=f.major,i=f.minor,t=[],c=l,r=0;r<=7;++r){for(u=c,o=0;o<=1;++o){for(n=0,a=0;a<=3;++a)n=3*n+(e.get(u)+1),u+=i;t.push(n+35)}if(c+=s,t>d)return d}return t},a=function(e){return String.fromCharCode.apply(String,(0,A.default)(e)).replace("\\","~")},c=function(e){return a(f(e))},l=function(e){var t,n,r,o,s;for(s=[Infinity],r=0,o=h.length;r<o;r++)n=h[r],t=f(e,n,s),t<s&&(s=t);return a(s)},u=function(e){var t,n,r,o,s;for(t=[],s=function(e,n){return n?(s(d(e/3),n-1),t.push(e%3)):t.push(e)},e=e.replace("~","\\"),r=o=0;o<=15;r=++o)n=e.charCodeAt(r)-35,s(n,3);return t.map(function(e){return m((0,_.default)(e)-1)}).join("")},e.exports={encode:c,encode_normalized:l,decode:u}},b04e:function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("button",{class:e.className,on:{click:function(t){return e.$emit("click")}}},[e._t("default")],2)},o=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return o})},b823:function(e,t,n){"use strict";n.r(t);var r=n("9d6c"),o=n.n(r);for(var s in r)"default"!==s&&function(e){n.d(t,e,function(){return r[e]})}(s);t["default"]=o.a},be17:function(e,t,n){"use strict";var r=n("288e");Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d");var o=n("fb4e"),s=r(n("357c"));n("d48d");var i=r(n("576b")),a=r(n("8ca1")),u=r(n("2a7d")),c=r(n("f4a7")),l=n("ce0b"),f={props:["start"],data:function(){return{levels:["easiest","easy","normal","hard","hardest"],color:(0,l.get_pref)("color",o.BLACK),level:(0,l.get_pref)("level","normal"),guide:(0,l.get_pref)("guide",!0),moves:(0,l.get_pref)("moves",!1),BLACK:o.BLACK,WHITE:o.WHITE,i18n:c.default}},methods:{submit:function(){return(0,l.set_pref)("color",this.color),(0,l.set_pref)("level",this.level),(0,l.set_pref)("guide",this.guide),(0,l.set_pref)("moves",this.moves),this.start(this.color,this.level,this.guide,this.moves)}},components:{Disc:s.default,CheckboxMarked:i.default,CheckboxBlankOutline:a.default,Button:u.default}};t.default=f},ce0b:function(e,t,n){"use strict";var r=n("288e");Object.defineProperty(t,"__esModule",{value:!0}),t.get_pref=t.set_pref=t.prefs=void 0;var o,s=r(n("f499"));n("cadf"),n("551c"),n("f751"),n("097d"),o="uctoth_prefs";var i=JSON.parse(localStorage[o]||"{}");t.prefs=i;var a=function(e,t){return i[e]=t,localStorage[o]=(0,s.default)(i)};t.set_pref=a;var u=function(e,t){var n;return null!=(n=i[e])?n:t};t.get_pref=u},cff9:function(e,t){e.exports="data:audio/mpeg;base64,SUQzBAAAAAAAI1RTU0UAAAAPAAADTGF2ZjU3LjgzLjEwMAAAAAAAAAAAAAAA//tAwAAAAAAAAAAAAAAAAAAAAAAASW5mbwAAAA8AAAADAAADKAB7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3u9vb29vb29vb29vb29vb29vb29vb29vb29vb29vb29vb3///////////////////////////////////////////8AAAAATGF2YzU3LjEwAAAAAAAAAAAAAAAAJAKjAAAAAAAAAyjcTOkNAAAAAAD/+1DEAAAKWKc4NPeAEXkXrvcekAIBPe79/fCcIIEfBziZpckACQAAANA7QBwA4GIb49Y9Z1vjkE3FzLm5tiGIY4MZOC4KCJm8e/vf//+l77xR5EpmlKUp//////R/HPiAMCQ5wQ/4YkiSIIKSUSabbjkkEAAlJ/kR3C6c1fEFmnIE5oefSOjIkxANohUSoFJClQuZvCGJJAm9Um16Pw37DYOSuG7DIR3Nt7t2o+tvEEveW34y93S1ocGnjS8g0FhZSW/1lBa7RIkJNdVnsdw7//tSxAUAC3SZY5zzADFwlWc09g4ZjHQrZ8pGM2EmgQCVHFHkkiCoonJnSWzJHJUclm6jkS2tRVEt/3lohktR0ureWn5+2opZFJ5igMHbip4yLhRpgGgZOjXSI92teCoaKgr2hMjVeLYAAAAAQ3QP6IUhpwXMQmIDsAZBDwiRzmwZwNcGzCH0ax+myckjUDZS4cPGJiWWjI5MXfhd77FxjbnHUMaxiPjHPil7HPdQQE9j5ddyEtouut43vjAXibf/yFbFgAAAAJN38eyZRA3iVDj/+1LEBwGLGKslJ6RywS0Kocg3mHgHeUQcwR1GE2SASYhAYpeSUukaZpSgVJpslZcTLgZQpmXkohZQoVp1S07ONRqxmPKRxm84pcFGv5qCFiQVSEnnT1f+n/6tmv///6RZq4ZmbTlUAKYbAaRIS8m8cRdTFCHF0GMwsKhRTnMWloKicSPCQYpPJhINFioCBkBERKIgdMLAXvypH39KxlPliv/1bMl//yJXS2lMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVQ=="},d72e:function(e,t,n){"use strict";var r=n("390c"),o=n.n(r);o.a},d8f6:function(e,t,n){"use strict";var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"wrapper",class:[e.will_flip&&"flip",e.color]},[n("svg",{attrs:{viewBox:"0 0 100 100",fill:"currentColor"}},[n("circle",{attrs:{cx:"50",cy:"50",r:"50"}})])])},o=[];n.d(t,"a",function(){return r}),n.d(t,"b",function(){return o})},db47:function(e,t,n){},e2ec:function(e,t,n){"use strict";n.r(t);var r=n("eaf8"),o=n.n(r);for(var s in r)"default"!==s&&function(e){n.d(t,e,function(){return r[e]})}(s);t["default"]=o.a},e5a2:function(e,t,n){e.exports=function(){return new Worker(n.p+"js/worker.de92e02feaedfe65892a.js")}},e6e0:function(e,t,n){"use strict";var r=n("3e75"),o=n.n(r);o.a},eaf8:function(e,t,n){"use strict";var r=n("e54b"),o=n("288e");Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0,n("cadf"),n("551c"),n("f751"),n("097d");var s=o(n("99b8")),i=o(n("c068")),a=o(n("4d77")),u=o(n("91ea")),c=o(n("521f")),l=o(n("2a7d")),f=o(n("f939")),d=o(n("f4a7")),v=r(n("2ba8")),h={props:["user","level","guide","show_moves","back"],data:function(){return{msg:null,msg_key:0,undo_enabled:!1,undo:function(){},muted:v.is_muted(),sound_supported:v.is_supported(),moves:"",entered_moves:"",i18n:d.default}},mounted:function(){return window.scrollTo(0,0)},computed:{level_title:function(){var e;return e=d.default.t[this.level],d.default.expand("mode",{mode:e})}},methods:{show_message:function(e){return this.msg_key++,this.msg=e},set_undo_btn:function(e,t){return this.undo_enabled=e,this.undo=t},mute:function(){return this.muted=!this.muted,v.mute(this.muted)},add_move:function(e){return this.moves+=e},undo_move:function(){return this.moves=this.moves.substr(0,this.moves.length-2)},enter_moves:function(e){return this.entered_moves=e},reset_moves:function(){return this.moves=""}},components:{BackIcon:s.default,SoundIcon:i.default,MuteIcon:a.default,Board:u.default,MessageBox:c.default,Button:l.default,Moves:f.default}};t.default=h},f0a0:function(e,t,n){"use strict";n.r(t);var r=n("85a1"),o=n.n(r);for(var s in r)"default"!==s&&function(e){n.d(t,e,function(){return r[e]})}(s);t["default"]=o.a},f346:function(e,t,n){"use strict";(function(t){var r=n("288e");n("aef6");var o=r(n("795b"));n("551c");var s=r(n("2d7d"));n("ac6a"),n("cadf"),n("5df3"),n("f400");var i,a,u,c,l,f,d,v,h,m,p=r(n("75fc"));n("f751"),n("097d"),v=function(e){var t,n,r,o,s;for(e=(0,p.default)(e),r=e.length,t=n=r-1;n>0;t=n+=-1)o=Math.random()*(t+1)|0,s=e[t],e[t]=e[o],e[o]=s;return e},l=function(e){var t;return t=new s.default,function(){for(var n,r=arguments.length,o=new Array(r),s=0;s<r;s++)o[s]=arguments[s];return n=t.get(o),void 0===n&&(n=e.apply(void 0,o),t.set(o)),n}},u=function(e){return 0|e},f=function(e,r){return new o.default(function(o){var s,i;return"-"===e?i=t.stdin:(i=n("3e8f").createReadStream(e),e.endsWith(".gz")&&(i=i.pipe(n("3e8f").createGunzip()))),s=n("3e8f").createInterface(i),s.on("line",function(e){return r(e)}),s.on("close",function(){return o()})})},a=function(e){var r,o;return"-"===e?t.stdout:(o=n("3e8f").createWriteStream(e),e.endsWith(".gz")?(r=n("3e8f").createGzip(),r.pipe(o),r):o)},c=function(e){var t,n,r,o,s,i,a,u;return t={},r={},r.prev=r.next=r,a=0,o=0,i=0,n=0,u=function(e){return e.next.prev=e.prev,e.prev.next=e.next},s=function(e){return e.prev=r,e.next=r.next,r.next.prev=e,r.next=e},{put:function(o,i){var c,l;return c=t[o],c?u(c):a>=e?(n+=1,l=r.prev,u(l),delete t[l.key]):a++,c={key:o,data:i},s(c),t[o]=c},get:function(e){var n;return n=t[e],n?(o+=1,n!==r.next&&(u(n),s(n)),n.data):(i+=1,null)},stats:function(){return{n:a,hit:o,miss:i,evict:n}}}},d=function(e){return Math.round(1e4*e)/1e4},i=1<<30,h=function(e,t){var r,o,s,i,a,u,c,l,f=arguments.length>2&&void 0!==arguments[2]?arguments[2]:null,d=n("ab69");for(s=d.encode_normalized,f||(f=e.list_moves(t)),o={},l=[],a=0,u=f.length;a<u;a++)c=f[a],i=e.move(t,c),r=s(e),e.undo(t,c,i),o[r]||(o[r]=!0,l.push(c));return l},m=function(e){var t,r,o;return t=n("3e8f"),r=function(){return t.existsSync(e)?t.statSync(e).mtime.getTime():null},o=r(),function(){var e;return e=r(),e!==o&&(o=e,!0)}},e.exports={shuffle:v,memoize:l,int:u,readlines:f,gzwriter:a,lru_cache:c,round_value:d,INFINITY:i,unique_moves:h,watch_file:m}}).call(this,n("4362"))},f4a7:function(e,t,n){"use strict";var r,o,s,i,a;n("a481"),n("7f7f"),n("28a5"),n("cadf"),n("551c"),n("f751"),n("097d");var u=n("ce0b");r=u.get_pref,i=u.set_pref,a={en:{first_move:"First move",second_move:"Second move",show_guide:"Show guide",show_moves:"Show record of moves",start:"Start",undo:"Undo",your_turn:"Your turn.",thinking:"Thinking...",you_pass:"You have no moves.",pass:"Pass",i_pass:"I have no moves. Your turn.",win:"You won by ${discs}!",lose:"You lost by ${discs}!",draw:"Draw!",play_again:"Play Again",easiest:"Very easy",easy:"Easy",normal:"Normal",hard:"Hard",hardest:"Very hard",mode:"${mode} mode",moves:"Moves",invalid_moves:"Incorrect moves."},ja:{first_move:"先手",second_move:"後手",show_guide:"ガイドを表示する",show_moves:"棋譜を表示する",start:"スタート",undo:"待った",your_turn:"あなたの番です。",thinking:"考えています...",you_pass:"あなたの打てるところがありません。",pass:"パス",i_pass:"私の打てるところがありません。あなたの番です。",win:"${discs}であなたの勝ちです!",lose:"${discs}であなたの負けです!",draw:"引き分け!",play_again:"もう一度プレイする",easiest:"超イージー",easy:"イージー",normal:"ノーマル",hard:"ハード",hardest:"超ハード",mode:"${mode}モード",moves:"棋譜",invalid_moves:"棋譜に誤りがあります"}},o=(r("lang")||(null!=(s=window.navigator.languages)?s[0]:void 0)||window.navigator.language||window.navigator.userLanguage||window.navigator.browserLanguage).split("-")[0],a[o]||(o="en"),e.exports={lang:o,t:a[o],expand:function(e,t){var n;if(n=this.t[e],!n)throw new Error("no translation");return n.replace(/\$\{(\w+)\}/g,function(e,n){return t[n]})},set:function(e){var t,n;if(n=a[e],n)return this.lang=e,this.t=n,i("lang",e),null!=(null!=(t=window.history)?t.replaceState:void 0)&&history.replaceState(null,"","."),document.querySelector("html").setAttribute("lang",e)}}},f571:function(e,t,n){"use strict";n.r(t);var r=n("be17"),o=n.n(r);for(var s in r)"default"!==s&&function(e){n.d(t,e,function(){return r[e]})}(s);t["default"]=o.a},f939:function(e,t,n){"use strict";n.r(t);var r=n("5cf2"),o=n("6965");for(var s in o)"default"!==s&&function(e){n.d(t,e,function(){return o[e]})}(s);n("5482");var i=n("2877"),a=Object(i["a"])(o["default"],r["a"],r["b"],!1,null,"6dd33386",null);t["default"]=a.exports},fb4e:function(e,t,n){"use strict";var r=n("288e"),o=r(n("f499"));n("ac6a"),n("28a5");var s=r(n("75fc")),i=r(n("d225")),a=r(n("b0b4")),u=r(n("2d7d"));n("cadf"),n("5df3"),n("f400");var c,l,f,d,v,h,m,p,_,A,b,q,g,y,k,w,x,C,E,S,j,B,M=r(n("e814"));n("551c"),n("f751"),n("097d");var I=n("f346");k=I.int,v=0,l=1,b=-1,m=2,E=function(e,t){return 9*(t+1)+(e+1)},C=function(e){var t,n;if(t=e.toLowerCase().charCodeAt(0)-"a".charCodeAt(0),n=(0,M.default)(e[1])-1,t<0||t>7||n<0||n>7)throw new Error("invalid position string");return E(t,n)},j=function(e){return{x:e%9-1,y:k(e/9)-1}},S=function(e){var t,n,r,o=arguments.length>1&&void 0!==arguments[1]?arguments[1]:l,s=j(e);return n=s.x,r=s.y,t=o===l?"A":"a",String.fromCharCode(t.charCodeAt(0)+n)+(r+1)},w=function(e){var t,n,r;n=/([a-hA-H][1-8])/g,r=[];while(1){if(t=n.exec(e),!t)break;r.push(C(t[0]))}return r},x=function(e){var t,n;return n=function(){var n,r,o;for(o=[],n=0,r=e.length;n<r;n++)t=e[n],null!=t.move&&null!=t.turn?o.push(S(t.move,t.turn)):o.push(S(t));return o}(),n.join("")},g={"-":v,X:l,O:b},y=function(e){return g[e]},B=function(){var e,t,n;return t=new u.default(function(){var t;for(e in t=[],g)n=g[e],t.push([n,e]);return t}()),function(e){return t.get(e)||"?"}}(),c=function(){var e,t,n,r,o;for(n=[],o=e=0;e<=7;o=++e)for(r=t=0;t<=7;r=++t)n.push(E(r,o));return n}(),q=[],q[C("B2")]=!0,q[C("G2")]=!0,q[C("B7")]=!0,q[C("G7")]=!0,A=-9,d=9,p=-1,_=1,h=function(){var e,t,n,r,o,s;for(r=[],s=t=0;t<=7;s=++t)for(o=n=0;n<=7;o=++n)r[E(o,s)]=e=[],o>1&&(e.push(p),s>1&&e.push(p+A),s<6&&e.push(p+d)),o<6&&(e.push(_),s>1&&e.push(_+A),s<6&&e.push(_+d)),s>1&&e.push(A),s<6&&e.push(d);return r}(),function(){var e,t,n,r,o,s,i,a;for(e=["A1","C1","A3","D1","A4","C3","D3","C4","D2","B4","B1","A2","C2","B3","B2","D4"],r=[],t=0,n=e.length;t<n;t++){s=e[t],o=C(s);var u=j(o);i=u.x,a=u.y,r.push(E(i,a)),r.push(E(7-i,a)),r.push(E(i,7-a)),r.push(E(7-i,7-a))}}(),f=function(){function e(t){(0,i.default)(this,e),t?"string"===typeof t?this.load(t):(this.board=(0,s.default)(t.board),this.build_empty_list()):this.load("- - - - - - - -\n- - - - - - - -\n- - - - - - - -\n- - - O X - - -\n- - - X O - - -\n- - - - - - - -\n- - - - - - - -\n- - - - - - - -")}return(0,a.default)(e,[{key:"load",value:function(e){var t,n,r,o,s,i,a,u,c;for(t=m,r=v,this.board=[t,t,t,t,t,t,t,t,t,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,r,r,r,r,r,r,r,r,t,t,t,t,t,t,t,t,t,t],u=0,c=0,i=e.split(""),o=0,s=i.length;o<s;o++)if(n=i[o],a=y(n),"undefined"!==typeof a){if(c>=8)throw new Error("too many cells");this.board[E(u,c)]=a,++u>=8&&(u=0,c++)}if(c<8)throw new Error("too few cells");return this.build_empty_list()}},{key:"dump",value:function(){var e,t,n,r,o,s,i,a=arguments.length>0&&void 0!==arguments[0]&&arguments[0];if(r=[],a){for(r.push(" "),s=e=0;e<=7;s=++e)r.push(" "),r.push(String.fromCharCode("A".charCodeAt(0)+s));r.push("\n")}for(i=t=0;t<=7;i=++t){for(a&&(r.push(i+1),r.push(" ")),s=n=0;n<=7;s=++n)r.push(B(this.board[E(s,i)])||"?"),a&&r.push(" ");a&&r.push(i+1),a&&r.push("\n")}if(a)for(r.push(" "),s=o=0;o<=7;s=++o)r.push(" "),r.push(String.fromCharCode("A".charCodeAt(0)+s));return r.join("")}},{key:"get",value:function(e){return this.board[e]}},{key:"count",value:function(e){var t,n=this;return t=0,c.forEach(function(r){if(n.board[r]===e)return t++}),t}},{key:"can_move",value:function(e,t){var n,r,o,s,i,a;if(this.board[t]===v)for(r=-e,a=h[t],o=0,s=a.length;o<s;o++)if(n=a[o],i=t+n,this.board[i]===r){i+=n;while(this.board[i]===r)i+=n;if(this.board[i]===e)return!0}return!1}},{key:"any_moves",value:function(e){var t,n=this;return t=!1,this.each_empty(function(r){if(n.can_move(e,r))return t=!0,!1}),t}},{key:"count_moves",value:function(e){var t,n=this;return t=0,this.each_empty(function(r){if(n.can_move(e,r))return t++}),t}},{key:"list_moves",value:function(e){var t,n=this;return t=[],this.each_empty(function(r){if(n.can_move(e,r))return t.push(r)}),t}},{key:"list_moves_but_x",value:function(e){var t,n=this;return t=[],this.each_empty(function(r){if(!q[r]&&n.can_move(e,r))return t.push(r)}),t}},{key:"move",value:function(e,t){var n,r,o,s,i,a,u,c=!(arguments.length>2&&void 0!==arguments[2])||arguments[2];if(r=[],this.board[t]===v){for(o=-e,u=h[t],s=0,i=u.length;s<i;s++)if(n=u[s],a=t+n,this.board[a]===o){a+=n;while(this.board[a]===o)a+=n;if(this.board[a]===e)while((a-=n)!==t)this.board[a]=e,r.push(a)}r.length&&(this.board[t]=e,c&&this.pop_empty_list(t))}return r}},{key:"count_flips",value:function(e,t){var n,r,o,s,i,a,u,c;if(r=0,this.board[t]===v)for(o=-e,c=h[t],s=0,i=c.length;s<i;s++){n=c[s],u=t+n,a=0;while(this.board[u]===o)u+=n,a++;this.board[u]===e&&(r+=a)}return r}},{key:"undo",value:function(e,t,n){var r,o,s,i,a=!(arguments.length>3&&void 0!==arguments[3])||arguments[3];for(r=-e,o=0,s=n.length;o<s;o++)i=n[o],this.board[i]=r;if(this.board[t]=v,a)return this.push_empty_list(t)}},{key:"score",value:function(e){var t,n,r=this;return t=-e,n=0,c.forEach(function(o){switch(r.board[o]){case e:return n++;case t:return n--}}),n}},{key:"outcome",value:function(){var e,t,n,r=this,o=arguments.length>0&&void 0!==arguments[0]?arguments[0]:l;return t=-o,n=0,e=0,c.forEach(function(s){switch(r.board[s]){case o:return n++;case t:return n--;case v:return e++}}),e&&(n>0?n+=e:n<0&&(n-=e)),n}},{key:"build_empty_list",value:function(){var e,t=this;return this.empty_next=[0],this.empty_prev=[0],e=0,c.forEach(function(n){if(t.board[n]===v)return t.empty_next[e]=n,t.empty_prev[n]=e,e=n}),this.empty_next[e]=0}},{key:"pop_empty_list",value:function(e){return this.empty_next[this.empty_prev[e]]=this.empty_next[e],this.empty_prev[this.empty_next[e]]=this.empty_prev[e]}},{key:"push_empty_list",value:function(e){return this.empty_next[this.empty_prev[e]]=e,this.empty_prev[this.empty_next[e]]=e}},{key:"first_empty",value:function(){return this.empty_next[0]}},{key:"each_empty",value:function(e){var t,n;t=0,n=[];while(1){if(t=this.empty_next[t],0===t)break;if(!1===e(t))break;n.push(void 0)}return n}},{key:"validate_empty_list",value:function(){var e,t,n=this;return t=0,this.each_empty(function(e){return console.assert(n.board[e]===v),t++}),e=0,c.forEach(function(t){if(n.board[t]===v)return e++}),console.assert(t===e)}},{key:"key",value:function(){return(0,o.default)(this.board)}}]),e}(),e.exports={EMPTY:v,BLACK:l,WHITE:b,GUARD:m,ALL_POSITIONS:c,UP:A,DOWN:d,LEFT:p,RIGHT:_,pos_from_xy:E,pos_from_str:C,pos_to_xy:j,pos_to_str:S,pos_array_from_str:w,pos_array_to_str:x,square_to_char:B,char_to_square:y,Board:f}}}]);
//# sourceMappingURL=chunk-common.84747771.js.map