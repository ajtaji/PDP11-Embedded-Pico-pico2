EnableExplicit
Global Acc.i, Op.i, Seed.i = 12345
OpenConsole()
Define i.i, t0.i, n.i = 200000000
Global Dim Code.a(65535)
For i = 0 To 65535 : Seed = (Seed * 1103515245 + 12345) & $7FFFFFFF : Code(i) = (Seed >> 8) & 255 : Next
! static void *jt[256] = {&&L0,&&L1,&&L2,&&L3,&&L4,&&L5,&&L6,&&L7,&&L8,&&L9,&&L10,&&L11,&&L12,&&L13,&&L14,&&L15,&&L16,&&L17,&&L18,&&L19,&&L20,&&L21,&&L22,&&L23,&&L24,&&L25,&&L26,&&L27,&&L28,&&L29,&&L30,&&L31,&&L32,&&L33,&&L34,&&L35,&&L36,&&L37,&&L38,&&L39,&&L40,&&L41,&&L42,&&L43,&&L44,&&L45,&&L46,&&L47,&&L48,&&L49,&&L50,&&L51,&&L52,&&L53,&&L54,&&L55,&&L56,&&L57,&&L58,&&L59,&&L60,&&L61,&&L62,&&L63,&&L64,&&L65,&&L66,&&L67,&&L68,&&L69,&&L70,&&L71,&&L72,&&L73,&&L74,&&L75,&&L76,&&L77,&&L78,&&L79,&&L80,&&L81,&&L82,&&L83,&&L84,&&L85,&&L86,&&L87,&&L88,&&L89,&&L90,&&L91,&&L92,&&L93,&&L94,&&L95,&&L96,&&L97,&&L98,&&L99,&&L100,&&L101,&&L102,&&L103,&&L104,&&L105,&&L106,&&L107,&&L108,&&L109,&&L110,&&L111,&&L112,&&L113,&&L114,&&L115,&&L116,&&L117,&&L118,&&L119,&&L120,&&L121,&&L122,&&L123,&&L124,&&L125,&&L126,&&L127,&&L128,&&L129,&&L130,&&L131,&&L132,&&L133,&&L134,&&L135,&&L136,&&L137,&&L138,&&L139,&&L140,&&L141,&&L142,&&L143,&&L144,&&L145,&&L146,&&L147,&&L148,&&L149,&&L150,&&L151,&&L152,&&L153,&&L154,&&L155,&&L156,&&L157,&&L158,&&L159,&&L160,&&L161,&&L162,&&L163,&&L164,&&L165,&&L166,&&L167,&&L168,&&L169,&&L170,&&L171,&&L172,&&L173,&&L174,&&L175,&&L176,&&L177,&&L178,&&L179,&&L180,&&L181,&&L182,&&L183,&&L184,&&L185,&&L186,&&L187,&&L188,&&L189,&&L190,&&L191,&&L192,&&L193,&&L194,&&L195,&&L196,&&L197,&&L198,&&L199,&&L200,&&L201,&&L202,&&L203,&&L204,&&L205,&&L206,&&L207,&&L208,&&L209,&&L210,&&L211,&&L212,&&L213,&&L214,&&L215,&&L216,&&L217,&&L218,&&L219,&&L220,&&L221,&&L222,&&L223,&&L224,&&L225,&&L226,&&L227,&&L228,&&L229,&&L230,&&L231,&&L232,&&L233,&&L234,&&L235,&&L236,&&L237,&&L238,&&L239,&&L240,&&L241,&&L242,&&L243,&&L244,&&L245,&&L246,&&L247,&&L248,&&L249,&&L250,&&L251,&&L252,&&L253,&&L254,&&L255};
t0 = ElapsedMilliseconds()
i = 0
Disp:
i + 1
If i > n : Goto Done : EndIf
Op = Code(i & 65535)
! goto *jt[g_op];
! L0:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L1:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L2:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L3:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L4:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L5:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L6:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L7:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L8:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L9:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L10:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L11:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L12:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L13:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L14:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L15:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L16:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L17:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L18:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L19:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L20:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L21:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L22:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L23:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L24:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L25:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L26:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L27:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L28:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L29:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L30:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L31:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L32:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L33:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L34:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L35:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L36:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L37:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L38:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L39:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L40:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L41:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L42:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L43:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L44:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L45:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L46:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L47:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L48:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L49:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L50:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L51:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L52:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L53:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L54:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L55:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L56:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L57:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L58:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L59:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L60:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L61:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L62:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L63:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L64:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L65:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L66:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L67:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L68:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L69:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L70:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L71:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L72:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L73:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L74:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L75:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L76:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L77:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L78:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L79:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L80:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L81:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L82:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L83:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L84:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L85:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L86:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L87:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L88:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L89:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L90:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L91:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L92:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L93:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L94:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L95:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L96:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L97:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L98:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L99:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L100:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L101:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L102:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L103:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L104:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L105:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L106:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L107:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L108:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L109:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L110:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L111:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L112:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L113:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L114:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L115:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L116:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L117:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L118:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L119:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L120:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L121:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L122:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L123:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L124:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L125:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L126:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L127:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L128:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L129:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L130:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L131:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L132:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L133:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L134:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L135:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L136:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L137:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L138:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L139:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L140:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L141:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L142:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L143:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L144:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L145:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L146:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L147:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L148:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L149:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L150:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L151:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L152:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L153:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L154:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L155:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L156:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L157:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L158:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L159:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L160:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L161:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L162:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L163:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L164:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L165:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L166:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L167:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L168:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L169:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L170:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L171:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L172:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L173:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L174:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L175:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L176:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L177:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L178:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L179:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L180:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L181:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L182:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L183:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L184:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L185:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L186:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L187:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L188:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L189:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L190:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L191:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L192:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L193:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L194:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L195:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L196:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L197:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L198:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L199:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L200:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L201:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L202:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L203:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L204:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L205:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L206:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L207:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L208:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L209:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L210:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L211:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L212:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L213:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L214:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L215:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L216:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L217:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L218:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L219:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L220:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L221:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L222:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L223:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L224:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L225:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L226:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L227:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L228:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L229:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L230:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L231:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L232:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L233:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L234:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L235:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L236:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L237:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L238:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L239:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L240:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L241:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L242:
Acc = Acc + 9 + (Op & 7)
Goto Disp
! L243:
Acc = Acc + 10 + (Op & 7)
Goto Disp
! L244:
Acc = Acc + 11 + (Op & 7)
Goto Disp
! L245:
Acc = Acc + 12 + (Op & 7)
Goto Disp
! L246:
Acc = Acc + 13 + (Op & 7)
Goto Disp
! L247:
Acc = Acc + 1 + (Op & 7)
Goto Disp
! L248:
Acc = Acc + 2 + (Op & 7)
Goto Disp
! L249:
Acc = Acc + 3 + (Op & 7)
Goto Disp
! L250:
Acc = Acc + 4 + (Op & 7)
Goto Disp
! L251:
Acc = Acc + 5 + (Op & 7)
Goto Disp
! L252:
Acc = Acc + 6 + (Op & 7)
Goto Disp
! L253:
Acc = Acc + 7 + (Op & 7)
Goto Disp
! L254:
Acc = Acc + 8 + (Op & 7)
Goto Disp
! L255:
Acc = Acc + 9 + (Op & 7)
Goto Disp
Done:
t0 = ElapsedMilliseconds() - t0
PrintN("computed goto:   " + Str(n) + " dispatches in " + Str(t0) + " ms = " + StrF(n / t0 / 1000.0, 1) + " M/s  acc=" + Str(Acc))
