! function(t) {
	function e() {
		function t(t, n, a) {
			for (var r, o, s, l = ([{
				x: 0,
				y: 0
			}, {
				x: e[0],
				y: e[1]
			}], n.x), i = n.y, h = Math.sqrt(e[0] * e[0] + e[1] * e[1]), d = v(e), f = Math.random() < .5 ? 1 : -1, p = -f;
			(r = d(p += f)) && (o = ~~r[0], s = ~~r[1], !(Math.min(o, s) > h));) if (n.x = l + o, n.y = i + s, !(n.x + n.x0 < 0 || n.y + n.y0 < 0 || n.x + n.x1 > e[0] || n.y + n.y1 > e[1] || a && u(n, t, e[0]) || a && !c(n, a))) {
				for (var y, g = n.sprite, x = n.width >> 5, m = e[0] >> 5, w = n.x - (x << 4), M = 127 & w, b = 32 - M, z = n.y1 - n.y0, C = (n.y + n.y0) * m + (w >> 5), T = 0; z > T; T++) {
					y = 0;
					for (var k = 0; x >= k; k++) t[C + k] |= y << b | (x > k ? (y = g[T * x + k]) >>> M : 0);
					C += m
				}
				return delete n.sprite, !0
			}
			return !1
		}
		var e = [256, 256],
			d = n,
			p = a,
			y = r,
			g = o,
			x = s,
			v = h,
			m = [],
			w = 1 / 0,
			b = d3.dispatch("word", "end"),
			z = null,
			C = {};
		return C.start = function() {
			function n() {
				for (var n, s = +new Date; + new Date - s < w && ++u < o && z;) n = h[u], n.x = e[0] * (Math.random() + .5) >> 1, n.y = e[1] * (Math.random() + .5) >> 1, l(n, h, u), t(a, n, r) && (c.push(n), b.word(n), r ? i(r, n) : r = [{
					x: n.x + n.x0,
					y: n.y + n.y0
				}, {
					x: n.x + n.x1,
					y: n.y + n.y1
				}], n.x -= e[0] >> 1, n.y -= e[1] >> 1);
				u >= o && (C.stop(), b.end(c, r))
			}
			var a = f((e[0] >> 5) * e[1]),
				r = null,
				o = m.length,
				u = -1,
				c = [],
				h = m.map(function(t, e) {
					return {
						text: d.call(this, t, e),
						font: p.call(this, t, e),
						rotate: g.call(this, t, e),
						size: ~~y.call(this, t, e),
						padding: s.call(this, t, e)
					}
				}).sort(function(t, e) {
					return e.size - t.size
				});
			return z && clearInterval(z), z = setInterval(n, 0), n(), C
		}, C.stop = function() {
			return z && (clearInterval(z), z = null), C
		}, C.timeInterval = function(t) {
			return arguments.length ? (w = null == t ? 1 / 0 : t, C) : w
		}, C.words = function(t) {
			return arguments.length ? (m = t, C) : m
		}, C.size = function(t) {
			return arguments.length ? (e = [+t[0], +t[1]], C) : e
		}, C.font = function(t) {
			return arguments.length ? (p = d3.functor(t), C) : p
		}, C.rotate = function(t) {
			return arguments.length ? (g = d3.functor(t), C) : g
		}, C.text = function(t) {
			return arguments.length ? (d = d3.functor(t), C) : d
		}, C.spiral = function(t) {
			return arguments.length ? (v = M[t + ""] || t, C) : v
		}, C.fontSize = function(t) {
			return arguments.length ? (y = d3.functor(t), C) : y
		}, C.padding = function(t) {
			return arguments.length ? (x = d3.functor(t), C) : x
		}, d3.rebind(C, b, "on")
	}
	function n(t) {
		return t.text
	}
	function a() {
		return "serif"
	}
	function r(t) {
		return Math.sqrt(t.value)
	}
	function o() {
		return 30 * (~~ (6 * Math.random()) - 3)
	}
	function s() {
		return 1
	}
	function l(t, e, n) {
		if (!t.sprite) {
			w.clearRect(0, 0, (g << 5) / v, x / v);
			var a = 0,
				r = 0,
				o = 0,
				s = e.length;
			for (n--; ++n < s;) {
				t = e[n], w.save(), w.font = ~~ ((t.size + 1) / v) + "px " + t.font;
				var l = w.measureText(t.text + "m").width * v,
					u = t.size << 1;
				if (t.rotate) {
					var i = Math.sin(t.rotate * y),
						c = Math.cos(t.rotate * y),
						h = l * c,
						d = l * i,
						f = u * c,
						p = u * i;
					l = Math.max(Math.abs(h + p), Math.abs(h - p)) + 31 >> 5 << 5, u = ~~Math.max(Math.abs(d + f), Math.abs(d - f))
				} else l = l + 31 >> 5 << 5;
				if (u > o && (o = u), a + l >= g << 5 && (a = 0, r += o, o = 0), r + u >= x) break;
				w.translate((a + (l >> 1)) / v, (r + (u >> 1)) / v), t.rotate && w.rotate(t.rotate * y), w.fillText(t.text, 0, 0), w.restore(), t.width = l, t.height = u, t.xoff = a, t.yoff = r, t.x1 = l >> 1, t.y1 = u >> 1, t.x0 = -t.x1, t.y0 = -t.y1, a += l
			}
			for (var m = w.getImageData(0, 0, (g << 5) / v, x / v).data, M = []; --n >= 0;) {
				t = e[n];
				for (var l = t.width, b = l >> 5, u = t.y1 - t.y0, z = t.padding, C = 0; u * b > C; C++) M[C] = 0;
				if (a = t.xoff, null == a) return;
				r = t.yoff;
				for (var T = 0, k = -1, A = 0; u > A; A++) {
					for (var C = 0; l > C; C++) {
						var L = b * A + (C >> 5),
							I = m[(r + A) * (g << 5) + (a + C) << 2] ? 1 << 31 - C % 32 : 0;
						z && (A && (M[L - b] |= I), l - 1 > A && (M[L + b] |= I), I |= I << 1 | I >> 1), M[L] |= I, T |= I
					}
					T ? k = A : (t.y0++, u--, A--, r++)
				}
				t.y1 = t.y0 + k, t.sprite = M.slice(0, (t.y1 - t.y0) * b)
			}
		}
	}
	function u(t, e, n) {
		n >>= 5;
		for (var a, r = t.sprite, o = t.width >> 5, s = t.x - (o << 4), l = 127 & s, u = 32 - l, i = t.y1 - t.y0, c = (t.y + t.y0) * n + (s >> 5), h = 0; i > h; h++) {
			a = 0;
			for (var d = 0; o >= d; d++) if ((a << u | (o > d ? (a = r[h * o + d]) >>> l : 0)) & e[c + d]) return !0;
			c += n
		}
		return !1
	}
	function i(t, e) {
		var n = t[0],
			a = t[1];
		e.x + e.x0 < n.x && (n.x = e.x + e.x0), e.y + e.y0 < n.y && (n.y = e.y + e.y0), e.x + e.x1 > a.x && (a.x = e.x + e.x1), e.y + e.y1 > a.y && (a.y = e.y + e.y1)
	}
	function c(t, e) {
		return t.x + t.x1 > e[0].x && t.x + t.x0 < e[1].x && t.y + t.y1 > e[0].y && t.y + t.y0 < e[1].y
	}
	function h(t) {
		var e = t[0] / t[1];
		return function(t) {
			return [e * (t *= .1) * Math.cos(t), t * Math.sin(t)]
		}
	}
	function d(t) {
		var e = 4,
			n = e * t[0] / t[1],
			a = 0,
			r = 0;
		return function(t) {
			var o = 0 > t ? -1 : 1;
			switch (3 & Math.sqrt(1 + 4 * o * t) - o) {
				case 0:
					a += n;
					break;
				case 1:
					r += e;
					break;
				case 2:
					a -= n;
					break;
				default:
					r -= e
			}
			return [a, r]
		}
	}
	function f(t) {
		for (var e = [], n = -1; ++n < t;) e[n] = 0;
		return e
	}
	var p, y = Math.PI / 180,
		g = 64,
		x = 2048,
		v = 1;
	if ("undefined" != typeof document) p = document.createElement("canvas"), p.width = 1, p.height = 1, v = Math.sqrt(p.getContext("2d").getImageData(0, 0, 1, 1).data.length >> 2), p.width = (g << 5) / v, p.height = x / v;
	else {
		var m = require("canvas");
		p = new m(g << 5, x)
	}
	var w = p.getContext("2d"),
		M = {
			archimedean: h,
			rectangular: d
		};
	w.fillStyle = "red", w.textAlign = "center", t.cloud = e
}("undefined" == typeof exports ? d3.layout || (d3.layout = {}) : exports);

var fill = d3.scale.category20b(),
	w = 960,
	h = 600,
	words = [],
	max, scale = 1,
	complete = 0,
	keyword = "",
	tags, fontSize, maxLength = 30,
	fetcher, statusText = d3.select("#status"),
	layout = d3.layout.cloud().timeInterval(10).size([w, h]).fontSize(function(t) {
		return fontSize(+t.value)
	}).text(function(t) {
		return t.key
	}).on("word", progress).on("end", draw),
	svg = d3.select("#vis").append("svg").attr("width", w).attr("height", h),
	background = svg.append("g"),
	vis = svg.append("g").attr("transform", "translate(" + [w >> 1, h >> 1] + ")");

function generate() {
	layout.font(d3.select("#font").property("value")).spiral(d3.select("input[name=spiral]:checked").property("value")), fontSize = d3.scale[d3.select("input[name=scale]:checked").property("value")]().range([10, 100]), tags.length && fontSize.domain([+tags[tags.length - 1].value || 1, +tags[0].value]), complete = 0, statusText.style("display", null), words = [], layout.stop().words(tags.slice(0, max = Math.min(tags.length, +d3.select("#max").property("value")))).start()
}

function progress() {
	statusText.text(++complete + "/" + max)
}
function draw(t, e) {
	statusText.style("display", "none"), scale = e ? Math.min(w / Math.abs(e[1].x - w / 2), w / Math.abs(e[0].x - w / 2), h / Math.abs(e[1].y - h / 2), h / Math.abs(e[0].y - h / 2)) / 2 : 1, words = t;
	var n = vis.selectAll("text").data(words, function(t) {
		return t.text.toLowerCase()
	});
	n.transition().duration(1e3).attr("transform", function(t) {
		return "translate(" + [t.x, t.y] + ")rotate(" + t.rotate + ")"
	}).style("font-size", function(t) {
		return t.size + "px"
	}), n.enter().append("text").attr("text-anchor", "middle").attr("transform", function(t) {
		return "translate(" + [t.x, t.y] + ")rotate(" + t.rotate + ")"
	}).style("font-size", "1px").transition().duration(1e3).style("font-size", function(t) {
		return t.size + "px"
	}), n.style("font-family", function(t) {
		return t.font
	}).style("fill", function(t) {
		return fill(t.text.toLowerCase())
	}).text(function(t) {
		return t.text
	});
	var a = background.append("g").attr("transform", vis.attr("transform")),
		r = a.node();
	n.exit().each(function() {
		r.appendChild(this)
	}), a.transition().duration(1e3).style("opacity", 1e-6).remove(), vis.transition().delay(1e3).duration(750).attr("transform", "translate(" + [w >> 1, h >> 1] + ")scale(" + scale + ")")
}

//Event listeners
$("#sympt").keyup(function(ev) {
	tags = d3.select("#sympt").property("value");
	tags = JSON.parse(tags);
	generate();
});

$('input[type=radio], #font, #max').change(function () {
	generate();
});
