(function(){
let en = window.location.href.indexOf("en") != -1
// menu
let menuTitle = title => m(".menu-title",  title)
let menuItem = s => m("a", {href: s.href}, m(".menu-item",  m(".menu-name",  s.name)))
// more
let card = (col, s) => m(".col.col-" + col, typeof s === "object" ? s.map(t => m("p", m.trust(t))) :  m.trust(s))
let content = s => [
s.content ? m(".more-content", s.content.map(t => m("p", m.trust(t)))) : '',
s.card ? m(".more-card", s.card.map(t => m(".more-card-item.row", [card(t.leftCol, t.left), card(t.rightCol, t.right)]))) : '',
]
let title = s => [m(".more-title", s.title), content(s)]
let open = s => [m(".more-name.open" + fontFit(s.name), {onclick: () => {s.open = false}}, m.trust('<p>' + s.name)), content(s)]
let close = s => [m(".more-name.close" + fontFit(s.name), {onclick: () => {s.open = true}}, m.trust('<p>' + s.name))]
let Item = {}, List = {}, Body = {}
Item.view = ({attrs}) => m(".more-item", attrs.title ? title(attrs) : attrs.open || attrs.open == null ? open(attrs) : close(attrs))
List.view = ({attrs}) => m(".more-list", attrs.data.map(s => m(Item, s)))
// other
let fontFit = s => !en && s.replace(/[\u0391-\uFFE5]/g,"11").length < 41 ? "" : ".font-10"

window.help = {
    menu: (data) => {
        m.render(document.body, m(".menu-list", data.map(s => s.title ? menuTitle(s.title) : menuItem(s))))
    },
	more: (data) => {
		let resolved = en ? "Resolved" : "已解决"
		let zanPushed = false
		let zan = () => !zanPushed ? m(".zan", {onclick: () => {zanPushed = true}}, resolved) : m(".zan.pushed", resolved)
        m.mount(document.body, {view: () => [m(List, {data}), zan()]})
    }
}
})()