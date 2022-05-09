"use strict";

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

(function () {
    var it = window.location.href.indexOf("it") != -1;
    // menu
    var menuTitle = function menuTitle(title) {
        return m(".menu-title", title);
    };
    var menuItem = function menuItem(s) {
        return m("a", { href: s.href }, m(".menu-item", m(".menu-name", s.name)));
    };
    // more
    var card = function card(col, s) {
        return m(".col.col-" + col, (typeof s === "undefined" ? "undefined" : _typeof(s)) === "object" ? s.map(function (t) {
            return m("p", m.trust(t));
        }) : m.trust(s));
    };
    var content = function content(s) {
        return [s.content ? m(".more-content", s.content.map(function (t) {
            return m("p", m.trust(t));
        })) : '', s.card ? m(".more-card", s.card.map(function (t) {
            return m(".more-card-item.row", [card(t.leftCol, t.left), card(t.rightCol, t.right)]);
        })) : ''];
    };
    var title = function title(s) {
        return [m(".more-title", s.title), content(s)];
    };
    var open = function open(s) {
        return [m(".more-name.open" + fontFit(s.name), {
            onclick: function onclick() {
                s.open = false;
            }
        }, m.trust('<p>' + s.name)), content(s)];
    };
    var close = function close(s) {
        return [m(".more-name.close" + fontFit(s.name), {
            onclick: function onclick() {
                s.open = true;
            }
        }, m.trust('<p>' + s.name))];
    };
    var Item = {},
        List = {},
        Body = {};
    Item.view = function (_ref) {
        var attrs = _ref.attrs;
        return m(".more-item", attrs.title ? title(attrs) : attrs.open || attrs.open == null ? open(attrs) : close(attrs));
    };
    List.view = function (_ref2) {
        var attrs = _ref2.attrs;
        return m(".more-list", attrs.data.map(function (s) {
            return m(Item, s);
        }));
    };
    // other
    var fontFit = function fontFit(s) {
        return ".font-10";
    };

    window.help = {
        menu: function menu(data) {
            m.render(document.body, m(".menu-list", data.map(function (s) {
                return s.title ? menuTitle(s.title) : menuItem(s);
            })));
        },
        more: function more(data) {
            if (it) {
                var resolved = "Risoluto";
                var zanPushed = false;
                var zan = function zan() {
                    return !zanPushed ? m(".zan", {
                        onclick: function onclick() {
                            zanPushed = true;
                        }
                    }, resolved) : m(".zan.pushed", resolved);
                };
                m.mount(document.body, { view: function view() {
                    return [m(List, { data: data })];
                } });
                return
            }

            m.mount(document.body, {
                view: function view() {
                    return [m(List, { data: data })];
                }
            });
        }
    };
})();