// @preserve jQuery.floatThead 1.2.11 - http://mkoryak.github.io/floatThead/ - Copyright (c) 2012 - 2014 Misha Koryak
// @license MIT
!function(a){function b(a,b,c){if(8==i){var d=n.width(),e=g.debounce(function(){var a=n.width();d!=a&&(d=a,c())},a);n.on(b,e)}else n.on(b,g.debounce(c,a))}function c(a){window.console&&window.console&&window.console.log&&window.console.log("jQuery.floatThead: "+a)}function d(){var b=a('<div style="width:50px;height:50px;overflow-y:scroll;position:absolute;top:-200px;left:-200px;"><div style="height:100px;width:100%"></div>');a("body").append(b);var c=b.innerWidth(),d=a("div",b).innerWidth();return b.remove(),c-d}function e(a){if(a.dataTableSettings)for(var b=0;b<a.dataTableSettings.length;b++){var c=a.dataTableSettings[b].nTable;if(a[0]==c)return!0}return!1}function f(a,b,c){var d=c?"outerWidth":"width";if(l&&a.css("max-width")){var e=0;c&&(e+=parseInt(a.css("borderLeft"),10),e+=parseInt(a.css("borderRight"),10));for(var f=0;f<b.length;f++)e+=b.get(f).offsetWidth;return e}return a[d]()}a.floatThead=a.floatThead||{},a.floatThead.defaults={cellTag:null,headerCellSelector:"tr:visible:first>*:visible",zIndex:1001,debounceResizeMs:10,useAbsolutePositioning:!0,scrollingTop:0,scrollingBottom:0,scrollContainer:function(){return a([])},getSizingRow:function(a){return a.find("tbody tr:visible:first>*:visible")},floatTableClass:"floatThead-table",floatWrapperClass:"floatThead-wrapper",floatContainerClass:"floatThead-container",copyTableClass:!0,enableAria:!1,autoReflow:!1,debug:!1};var g=window._,h="undefined"!=typeof MutationObserver,i=function(){for(var a=3,b=document.createElement("b"),c=b.all||[];a=1+a,b.innerHTML="<!--[if gt IE "+a+"]><i><![endif]-->",c[0];);return a>4?a:document.documentMode}(),j=/Gecko\//.test(navigator.userAgent),k=/WebKit\//.test(navigator.userAgent),l=function(){if(k){var b=a('<div style="width:0px"><table style="max-width:100%"><tr><th><div style="min-width:100px;">X</div></th></tr></table></div>');a("body").append(b);var c=0==b.find("table").width();return b.remove(),c}return!1},m=!j&&!i,n=a(window);a.fn.floatThead=function(j){if(j=j||{},!g&&(g=window._||a.floatThead._,!g))throw new Error("jquery.floatThead-slim.js requires underscore. You should use the non-lite version since you do not have underscore.");if(8>i)return this;m&&(document.createElement("fthtr"),document.createElement("fthtd"),document.createElement("fthfoot"));var o=null;if(g.isFunction(l)&&(l=l()),g.isString(j)){var p=j,q=this;return this.filter("table").each(function(){var b=a(this).data("floatThead-attached");if(b&&g.isFunction(b[p])){var c=b[p]();"undefined"!=typeof c&&(q=c)}}),q}var r=a.extend({},a.floatThead.defaults||{},j);if(a.each(j,function(b){b in a.floatThead.defaults||!r.debug||c("Used ["+b+"] key to init plugin, but that param is not an option for the plugin. Valid options are: "+g.keys(a.floatThead.defaults).join(", "))}),r.debug){var s=a.fn.jquery.split(".");1==parseInt(s[0],10)&&parseInt(s[1],10)<=7&&c("jQuery version "+a.fn.jquery+" detected! This plugin supports 1.8 or better, or 1.7.x with jQuery UI 1.8.24 -> http://jqueryui.com/resources/download/jquery-ui-1.8.24.zip")}return this.filter(":not(."+r.floatTableClass+")").each(function(){function c(a){return a+".fth-"+B+".floatTHead"}function j(){var b=0;D.find("tr:visible").each(function(){b+=a(this).outerHeight(!0)}),bb.outerHeight(b),cb.outerHeight(b)}function l(){var a=f(C,fb,!0),b=L.width()||a,c="hidden"!=L.css("overflow-y")?b-I.vertical:b;if($.width(c),R){var d=100*a/c;V.css("width",d+"%")}else V.outerWidth(a)}function p(){F=(g.isFunction(r.scrollingTop)?r.scrollingTop(C):r.scrollingTop)||0,G=(g.isFunction(r.scrollingBottom)?r.scrollingBottom(C):r.scrollingBottom)||0}function q(){var b,c;if(Y)b=X.find("col").length;else{var d;if(d=null==r.cellTag&&r.headerCellSelector?r.headerCellSelector:"tr:first>"+r.cellTag,g.isNumber(d))return d;c=D.find(d),b=0,c.each(function(){b+=parseInt(a(this).attr("colspan")||1,10)})}if(b!=K){K=b;for(var e,f=[],h=[],i=[],j=0;b>j;j++)f.push(r.enableAria&&(e=c.eq(j).text())?'<th scope="col" class="floatThead-col">'+e+"</th>":'<th class="floatThead-col"/>'),h.push("<col/>"),i.push("<fthtd style='display:table-cell;height:0;width:auto;'/>");h=h.join(""),f=f.join(""),m&&(i=i.join(""),Z.html(i),fb=Z.find("fthtd")),bb.html(f),cb=bb.find("th"),Y||X.html(h),db=X.find("col"),W.html(h),eb=W.find("col")}return b}function s(){if(!H){if(H=!0,M){var a=f(C,fb),b=T.width();a>b&&C.css("minWidth",a)}C.css(ib),V.css(ib),V.append(D),E.before(ab),j()}}function t(){H&&(H=!1,M&&C.width(kb),ab.detach(),C.prepend(D),C.css(jb),V.css(jb),C.css("minWidth",lb),C.css("minWidth",f(C,fb)))}function u(a){M!=a&&(M=a,$.css({position:M?"absolute":"fixed"}))}function v(a,b,c,d){return m?c:d?r.getSizingRow(a,b,c):b}function w(){var a,b=q();return function(){db=X.find("col");var c=v(C,db,fb,i);if(c.length==b&&b>0){if(!Y)for(a=0;b>a;a++)db.eq(a).css("width","");t();var d=[];for(a=0;b>a;a++)d[a]=c.get(a).offsetWidth;for(a=0;b>a;a++)eb.eq(a).width(d[a]),db.eq(a).width(d[a]);s()}else V.append(D),C.css(jb),V.css(jb),j()}}function x(a){var b=L.css("border-"+a+"-width"),c=0;return b&&~b.indexOf("px")&&(c=parseInt(b,10)),c}function y(){var a,b=L.scrollTop(),c=0,d=O?N.outerHeight(!0):0,e=P?d:-d,f=$.height(),g=C.offset(),h=0;if(R){var i=L.offset();c=g.top-i.top+b,O&&P&&(c+=d),c-=x("top"),h=x("left")}else a=g.top-F-f+G+I.horizontal;var j=n.scrollTop(),l=n.scrollLeft(),m=L.scrollLeft();return b=L.scrollTop(),function(i){var o=C[0].offsetWidth<=0&&C[0].offsetHeight<=0;if(!o&&_)return _=!1,setTimeout(function(){C.trigger("reflow")},1),null;if(o&&(_=!0,!M))return null;if("windowScroll"==i?(j=n.scrollTop(),l=n.scrollLeft()):"containerScroll"==i?(b=L.scrollTop(),m=L.scrollLeft()):"init"!=i&&(j=n.scrollTop(),l=n.scrollLeft(),b=L.scrollTop(),m=L.scrollLeft()),!k||!(0>j||0>l)){if(U)u("windowScrollDone"==i?!0:!1);else if("windowScrollDone"==i)return null;g=C.offset(),O&&P&&(g.top+=d);var p,q,r=C.outerHeight();if(R&&M){if(c>=b){var v=c-b;p=v>0?v:0}else p=S?0:b;q=h}else!R&&M?(j>a+r+e?p=r-f+e:g.top>j+F?(p=0,t()):(p=F+j-g.top+c+(P?d:0),s()),q=0):R&&!M?(c>b||b-c>r?(p=g.top-j,t()):(p=g.top+b-j-c,s()),q=g.left+m-l):R||M||(j>a+r+e?p=r+F-j+a+e:g.top>j+F?(p=g.top-j,s()):p=F,q=g.left-l);return{top:p,left:q}}}}function z(){var a=null,b=null,c=null;return function(d,e,f){null==d||a==d.top&&b==d.left||($.css({top:d.top,left:d.left}),a=d.top,b=d.left),e&&l(),f&&j();var g=L.scrollLeft();M&&c==g||($.scrollLeft(g),c=g)}}function A(){if(L.length)if(L.data().perfectScrollbar)I={horizontal:0,vertical:0};else{var a=L.width(),b=L.height(),c=C.height(),d=f(C,fb),e=d>a?J:0,g=c>b?J:0;I.horizontal=d>a-g?J:0,I.vertical=c>b-e?J:0}}var B=g.uniqueId(),C=a(this);if(C.data("floatThead-attached"))return!0;if(!C.is("table"))throw new Error('jQuery.floatThead must be run on a table element. ex: $("table").floatThead();');h=r.autoReflow&&h;var D=C.find("thead:first"),E=C.find("tbody:first");if(0==D.length)throw new Error("jQuery.floatThead must be run on a table that contains a <thead> element");var F,G,H=!1,I={vertical:0,horizontal:0},J=d(),K=0,L=r.scrollContainer(C)||a([]),M=r.useAbsolutePositioning;null==M&&(M=r.scrollContainer(C).length),M||(H=!0);var N=C.find("caption"),O=1==N.length;if(O)var P="top"===(N.css("caption-side")||N.attr("align")||"top");var Q=a('<fthfoot style="display:table-footer-group;border-spacing:0;height:0;border-collapse:collapse;"/>'),R=L.length>0,S=!1,T=a([]),U=9>=i&&!R&&M,V=a("<table/>"),W=a("<colgroup/>"),X=C.find("colgroup:first"),Y=!0;0==X.length&&(X=a("<colgroup/>"),Y=!1);var Z=a('<fthrow style="display:table-row;border-spacing:0;height:0;border-collapse:collapse"/>'),$=a('<div style="overflow: hidden;" aria-hidden="true" class="floatThead-floatContainer"></div>'),_=!1,ab=a("<thead/>"),bb=a('<tr class="size-row"/>'),cb=a([]),db=a([]),eb=a([]),fb=a([]);ab.append(bb),C.prepend(X),m&&(Q.append(Z),C.append(Q)),V.append(W),$.append(V),r.copyTableClass&&V.attr("class",C.attr("class")),V.attr({cellpadding:C.attr("cellpadding"),cellspacing:C.attr("cellspacing"),border:C.attr("border")});var gb=C.css("display");if(V.css({borderCollapse:C.css("borderCollapse"),border:C.css("border"),display:gb}),"none"==gb&&(_=!0),V.addClass(r.floatTableClass).css("margin",0),M){var hb=function(a,b){var c=a.css("position"),d="relative"==c||"absolute"==c;if(!d||b){var e={paddingLeft:a.css("paddingLeft"),paddingRight:a.css("paddingRight")};$.css(e),a=a.wrap("<div class='"+r.floatWrapperClass+"' style='position: relative; clear:both;'></div>").parent(),S=!0}return a};R?(T=hb(L,!0),T.append($)):(T=hb(C),C.after($))}else C.after($);$.css({position:M?"absolute":"fixed",marginTop:0,top:M?0:"auto",zIndex:r.zIndex}),$.addClass(r.floatContainerClass),p();var ib={"table-layout":"fixed"},jb={"table-layout":C.css("tableLayout")||"auto"},kb=C[0].style.width||"",lb=C.css("minWidth")||"";A();var mb,nb=function(){(mb=w())()};nb();var ob=y(),pb=z();pb(ob("init"),!0);var qb=g.debounce(function(){pb(ob("windowScrollDone"),!1)},300),rb=function(){pb(ob("windowScroll"),!1),qb()},sb=function(){pb(ob("containerScroll"),!1)},tb=function(){p(),A(),nb(),ob=y(),(pb=z())(ob("resize"),!0,!0)},ub=g.debounce(function(){A(),p(),nb(),ob=y(),pb(ob("reflow"),!0)},1);if(R?M?L.on(c("scroll"),sb):(L.on(c("scroll"),sb),n.on(c("scroll"),rb)):n.on(c("scroll"),rb),n.on(c("load"),ub),b(r.debounceResizeMs,c("resize"),tb),C.on("reflow",ub),e(C)&&C.on("filter",ub).on("sort",ub).on("page",ub),h){var vb=L.length?L[0]:C[0];o=new MutationObserver(function(a){for(var b=function(a){return a&&a[0]&&"THEAD"==a[0].nodeName},c=0;c<a.length;c++)if(!b(a[c].addedNodes)&&!b(a[c].removedNodes)){ub();break}}),o.observe(vb,{childList:!0,subtree:!0})}C.data("floatThead-attached",{destroy:function(){var a=".fth-"+B;t(),C.css(jb),X.remove(),m&&Q.remove(),ab.parent().length&&ab.replaceWith(D),h&&(o.disconnect(),o=null),C.off("reflow"),L.off(a),S&&(L.length?L.unwrap():C.unwrap()),C.css("minWidth",lb),$.remove(),C.data("floatThead-attached",!1),n.off(a)},reflow:function(){ub()},setHeaderHeight:function(){j()},getFloatContainer:function(){return $},getRowGroups:function(){return H?$.find("thead").add(C.find("tbody,tfoot")):C.find("thead,tbody,tfoot")}})}),this}}(jQuery),function(a){a.floatThead=a.floatThead||{},a.floatThead._=window._||function(){var b={},c=Object.prototype.hasOwnProperty,d=["Arguments","Function","String","Number","Date","RegExp"];b.has=function(a,b){return c.call(a,b)},b.keys=function(a){if(a!==Object(a))throw new TypeError("Invalid object");var c=[];for(var d in a)b.has(a,d)&&c.push(d);return c};var e=0;return b.uniqueId=function(a){var b=++e+"";return a?a+b:b},a.each(d,function(){var a=this;b["is"+a]=function(b){return Object.prototype.toString.call(b)=="[object "+a+"]"}}),b.debounce=function(a,b,c){var d,e,f,g,h;return function(){f=this,e=arguments,g=new Date;var i=function(){var j=new Date-g;b>j?d=setTimeout(i,b-j):(d=null,c||(h=a.apply(f,e)))},j=c&&!d;return d||(d=setTimeout(i,b)),j&&(h=a.apply(f,e)),h}},b}()}(jQuery);