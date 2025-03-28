
// Module names are of the form poly_<inkscape-path-id>().  As a result,
// you can associate a polygon in this OpenSCAD program with the corresponding
// SVG element in the Inkscape document by looking for the XML element with
// the attribute id="inkscape-path-id".

// fudge value is used to ensure that subtracted solids are a tad taller
// in the z dimension than the polygon being subtracted from.  This helps
// keep the resulting .stl file manifold.
fudge = 0.1;

module poly_path3069(h)
{
  scale([25.4/90, -25.4/90, 1]) union()
  {
    linear_extrude(height=h)
      polygon([[228.553814,-419.124434],[227.930966,-413.945329],[226.934718,-409.100539],[225.562299,-404.572097],[223.810936,-400.342035],[221.677859,-396.392386],[219.160297,-392.705182],[216.255476,-389.262455],[212.960626,-386.046237],[209.272975,-383.038560],[205.189753,-380.221458],[200.708186,-377.576961],[195.825503,-375.087103],[184.845706,-370.499430],[172.228189,-366.314697],[157.950778,-362.389162],[141.991302,-358.579084],[104.937464,-350.730327],[60.889294,-341.618490],[36.186904,-336.229562],[9.669414,-330.093637],[-66.960162,-311.398175],[-100.864258,-303.262783],[-131.983994,-296.290993],[-160.436448,-290.749335],[-173.699030,-288.598097],[-186.338695,-286.904341],[-198.370078,-285.701384],[-209.807812,-285.022542],[-220.666533,-284.901131],[-230.960875,-285.370469],[-240.705473,-286.463870],[-249.914960,-288.214652],[-258.603973,-290.656131],[-266.787145,-293.821624],[-274.479110,-297.744446],[-281.694504,-302.457915],[-288.447960,-307.995346],[-294.754114,-314.390056],[-300.627600,-321.675362],[-306.083052,-329.884579],[-311.135106,-339.051025],[-315.798394,-349.208014],[-320.087553,-360.388865],[-324.017217,-372.626894],[-327.602020,-385.955415],[-330.856596,-400.407747],[-332.357385,-409.294472],[-333.108458,-417.716753],[-333.121094,-425.695506],[-332.406570,-433.251646],[-330.976164,-440.406088],[-328.841155,-447.179748],[-326.012821,-453.593540],[-322.502440,-459.668380],[-318.321290,-465.425183],[-313.480650,-470.884865],[-307.991797,-476.068340],[-301.866009,-480.996524],[-295.114566,-485.690333],[-287.748744,-490.170680],[-279.779822,-494.458483],[-271.219079,-498.574655],[-262.077792,-502.540112],[-252.367239,-506.375770],[-231.283450,-513.741347],[-208.057936,-520.838708],[-182.780924,-527.835176],[-126.433302,-542.194718],[-62.962386,-558.158548],[-30.880690,-566.172203],[-1.346602,-572.954838],[25.761432,-578.437199],[50.564967,-582.550034],[62.140533,-584.071237],[73.185558,-585.224088],[83.715235,-585.999931],[93.744759,-586.390108],[103.289325,-586.385963],[112.364126,-585.978839],[120.984358,-585.160080],[129.165214,-583.921029],[136.921888,-582.253028],[144.269576,-580.147422],[151.223471,-577.595553],[157.798768,-574.588765],[164.010661,-571.118402],[169.874345,-567.175806],[175.405013,-562.752320],[180.617860,-557.839288],[185.528082,-552.428054],[190.150871,-546.509960],[194.501422,-540.076350],[198.594930,-533.118567],[202.446588,-525.627954],[206.071592,-517.595855],[209.485136,-509.013613],[212.702414,-499.872571],[216.876846,-486.839043],[220.437107,-474.731840],[223.376997,-463.507801],[225.690314,-453.123765],[227.370855,-443.536571],[228.412420,-434.703058],[228.808807,-426.580066],[228.553814,-419.124434]]);
  }
}

module poly_path3071(h)
{
  scale([25.4/90, -25.4/90, 1]) union()
  {
    linear_extrude(height=h)
      polygon([[370.147314,-626.709177],[368.608520,-662.285091],[368.064278,-697.233916],[368.425062,-731.523822],[369.601342,-765.122979],[371.503593,-797.999554],[374.042285,-830.121717],[377.127893,-861.457637],[380.670887,-891.975482],[384.581741,-921.643422],[388.770927,-950.429626],[397.626186,-1005.229499],[414.737476,-1102.847840],[421.561068,-1145.157011],[424.226504,-1164.575188],[426.274996,-1182.793317],[427.617018,-1199.779568],[428.163042,-1215.502110],[427.823540,-1229.929112],[426.508984,-1243.028741],[425.458084,-1249.070845],[424.129847,-1254.769169],[422.513084,-1260.119734],[420.596602,-1265.118562],[418.369212,-1269.761674],[415.819722,-1274.045091],[412.936940,-1277.964834],[409.709677,-1281.516924],[406.126741,-1284.697383],[402.176942,-1287.502231],[397.849087,-1289.927489],[393.131988,-1291.969179],[388.014451,-1293.623322],[382.485287,-1294.885938],[376.533305,-1295.753050],[370.147314,-1296.220677],[344.791061,-1296.763925],[318.921998,-1296.377248],[292.570642,-1295.072841],[265.767514,-1292.862898],[238.543130,-1289.759612],[210.928008,-1285.775176],[182.952668,-1280.921784],[154.647628,-1275.211631],[126.043405,-1268.656908],[97.170518,-1261.269811],[68.059485,-1253.062533],[38.740825,-1244.047266],[9.245056,-1234.236206],[-20.397303,-1223.641545],[-50.155736,-1212.275476],[-79.999722,-1200.150195],[-109.898745,-1187.277894],[-139.822285,-1173.670766],[-169.739825,-1159.341006],[-199.620846,-1144.300807],[-229.434829,-1128.562363],[-259.151257,-1112.137867],[-288.739612,-1095.039512],[-318.169374,-1077.279494],[-347.410026,-1058.870004],[-376.431050,-1039.823237],[-405.201926,-1020.151386],[-433.692137,-999.866644],[-461.871165,-978.981207],[-489.708491,-957.507266],[-517.173597,-935.457016],[-544.235965,-912.842650],[-570.865076,-889.676362],[-597.030413,-865.970345],[-622.701456,-841.736794],[-647.847687,-816.987901],[-672.438589,-791.735860],[-696.443643,-765.992865],[-719.832330,-739.771110],[-742.574133,-713.082787],[-764.638533,-685.940091],[-785.995012,-658.355216],[-806.613051,-630.340354],[-826.462133,-601.907700],[-845.511738,-573.069446],[-863.731350,-543.837788],[-881.090448,-514.224917],[-897.558516,-484.243029],[-913.105034,-453.904315],[-927.699486,-423.220971],[-941.311351,-392.205190],[-953.910112,-360.869165],[-965.465251,-329.225089],[-975.946249,-297.285157],[-985.322589,-265.061562],[-993.563751,-232.566498],[-997.249104,-216.220975],[-1000.639218,-199.812158],[-1003.730279,-183.341570],[-1006.518471,-166.810735],[-1008.999980,-150.221179],[-1011.170992,-133.574424],[-1013.027691,-116.871996],[-1014.566263,-100.115418],[-1015.782892,-83.306215],[-1016.673765,-66.445911],[-1017.235066,-49.536030],[-1017.462980,-32.578096],[-1017.353693,-15.573634],[-1016.903390,1.475833],[-1016.108256,18.568780],[-1014.964476,35.703683],[-1013.489069,52.855984],[-1011.704171,70.000361],[-1009.613648,87.134138],[-1007.221363,104.254639],[-1001.546967,138.445112],[-994.711902,172.550377],[-986.747083,206.549031],[-977.683427,240.419670],[-967.551851,274.140889],[-956.383272,307.691286],[-944.208607,341.049457],[-931.058771,374.193998],[-916.964683,407.103505],[-901.957259,439.756575],[-886.067415,472.131805],[-869.326068,504.207789],[-851.764135,535.963126],[-833.412533,567.376410],[-814.302179,598.426240],[-794.463988,629.091210],[-773.928879,659.349917],[-752.727767,689.180958],[-730.891570,718.562928],[-708.451204,747.474425],[-685.437585,775.894044],[-661.881632,803.800383],[-637.814259,831.172036],[-613.266385,857.987601],[-588.268926,884.225674],[-562.852798,909.864851],[-537.048919,934.883729],[-510.888205,959.260904],[-484.401573,982.974972],[-457.619939,1006.004530],[-430.574220,1028.328174],[-403.295334,1049.924500],[-375.814196,1070.772105],[-348.161724,1090.849584],[-320.368835,1110.135536],[-292.466444,1128.608554],[-264.485469,1146.247237],[-236.456826,1163.030180],[-208.411433,1178.935980],[-180.380206,1193.943233],[-152.394061,1208.030536],[-124.483916,1221.176484],[-96.680688,1233.359674],[-69.015292,1244.558703],[-41.518646,1254.752166],[-14.221666,1263.918661],[12.844731,1272.036783],[39.649627,1279.085129],[66.162107,1285.042295],[92.351254,1289.886877],[118.186150,1293.597473],[143.635880,1296.152677],[168.669526,1297.531087],[181.020656,1297.772306],[193.256171,1297.711299],[205.372208,1297.345392],[217.364900,1296.671909],[229.230384,1295.688175],[240.964794,1294.391514],[252.564268,1292.779251],[264.024938,1290.848710],[275.342942,1288.597215],[286.514415,1286.022092],[297.535492,1283.120665],[308.402308,1279.890259],[319.110998,1276.328197],[329.657699,1272.431805],[340.038546,1268.198407],[350.249674,1263.625327],[360.287218,1258.709891],[370.147314,1253.449423],[389.332733,1242.209194],[407.816917,1230.241474],[425.612255,1217.572451],[442.731135,1204.228312],[459.185948,1190.235247],[474.989082,1175.619442],[490.152927,1160.407088],[504.689872,1144.624372],[518.612307,1128.297482],[531.932620,1111.452606],[544.663202,1094.115934],[556.816441,1076.313652],[568.404727,1058.071950],[579.440449,1039.417015],[589.935996,1020.375037],[599.903757,1000.972202],[609.356123,981.234700],[618.305482,961.188719],[626.764224,940.860447],[634.744737,920.276073],[642.259412,899.461784],[649.320637,878.443768],[655.940802,857.248215],[662.132296,835.901313],[667.907508,814.429249],[673.278828,792.858212],[678.258646,771.214391],[682.859349,749.523973],[687.093329,727.813147],[690.972973,706.108101],[694.510671,684.435023],[697.718814,662.820103],[703.195986,619.869484],[707.503605,577.465752],[710.740784,535.818412],[713.006638,495.136970],[714.400282,455.630934],[715.020829,417.509808],[714.967396,380.983100],[714.339095,346.260315],[713.235042,313.550960],[711.754350,283.064541],[709.996135,255.010565],[708.059511,229.598536],[704.047494,187.538350],[700.511214,158.560033],[698.287738,142.719703],[695.752193,127.278635],[692.915162,112.222994],[689.787234,97.538946],[686.378995,83.212655],[682.701030,69.230289],[678.763927,55.578012],[674.578272,42.241989],[670.154651,29.208387],[665.503651,16.463370],[655.561858,-8.216244],[644.837586,-31.907528],[633.415525,-54.721158],[621.380366,-76.767811],[608.816803,-98.158161],[595.809525,-119.002885],[582.443225,-139.412658],[568.802593,-159.498156],[554.972322,-179.370056],[527.081626,-218.915760],[499.448669,-258.935177],[485.940571,-279.399218],[472.750982,-300.313714],[459.964594,-321.789341],[447.666097,-343.936775],[435.940184,-366.866692],[424.871546,-390.689768],[414.544875,-415.516678],[409.686242,-428.341157],[405.044861,-441.458099],[400.631317,-454.881336],[396.456196,-468.624705],[392.530086,-482.702039],[388.863572,-497.127173],[385.467242,-511.913941],[382.351681,-527.076178],[379.527476,-542.627719],[377.005213,-558.582397],[374.795479,-574.954048],[372.908860,-591.756505],[371.355943,-609.003603],[370.147314,-626.709177]]);
  }
}

module poly_path3853(h)
{
  scale([25.4/90, -25.4/90, 1]) union()
  {
    linear_extrude(height=h)
      polygon([[857.005314,-424.560485],[856.022455,-416.457458],[854.663952,-408.498488],[852.940240,-400.692572],[850.861753,-393.048707],[848.438923,-385.575887],[845.682185,-378.283109],[842.601973,-371.179370],[839.208720,-364.273665],[835.512860,-357.574990],[831.524827,-351.092342],[827.255055,-344.834716],[822.713978,-338.811109],[817.912028,-333.030516],[812.859641,-327.501933],[807.567250,-322.234358],[802.045289,-317.236785],[796.304191,-312.518210],[790.354390,-308.087631],[784.206320,-303.954043],[777.870415,-300.126441],[771.357109,-296.613822],[764.676835,-293.425183],[757.840027,-290.569518],[750.857120,-288.055825],[743.738546,-285.893099],[736.494740,-284.090336],[729.136135,-282.656533],[721.673165,-281.600685],[714.116264,-280.931788],[706.475866,-280.658839],[698.762405,-280.790833],[690.986314,-281.336767],[683.250074,-282.293384],[675.654916,-283.644208],[668.209342,-285.378409],[660.921853,-287.485158],[653.800952,-289.953624],[646.855140,-292.772977],[640.092919,-295.932387],[633.522792,-299.421023],[627.153259,-303.228055],[620.992823,-307.342654],[615.049985,-311.753988],[609.333248,-316.451229],[603.851112,-321.423545],[598.612081,-326.660106],[593.624656,-332.150083],[588.897339,-337.882644],[584.438631,-343.846961],[580.257034,-350.032202],[576.361051,-356.427538],[572.759183,-363.022138],[569.459932,-369.805172],[566.471799,-376.765810],[563.803287,-383.893221],[561.462898,-391.176577],[559.459133,-398.605045],[557.800494,-406.167797],[556.495483,-413.854002],[555.552602,-421.652829],[554.980353,-429.553449],[554.787237,-437.545032],[554.981757,-445.616747],[555.572414,-453.757763],[556.555183,-461.860800],[557.913425,-469.819796],[559.636716,-477.625753],[561.714634,-485.269674],[564.136758,-492.742562],[566.892664,-500.035420],[569.971931,-507.139250],[573.364135,-514.045057],[577.058856,-520.743842],[581.045670,-527.226608],[585.314155,-533.484358],[589.853888,-539.508095],[594.654448,-545.288822],[599.705412,-550.817542],[604.996358,-556.085257],[610.516864,-561.082971],[616.256506,-565.801685],[622.204863,-570.232404],[628.351513,-574.366130],[634.686033,-578.193865],[641.198000,-581.706614],[647.876993,-584.895377],[654.712590,-587.751159],[661.694367,-590.264962],[668.811902,-592.427789],[676.054774,-594.230642],[683.412560,-595.664526],[690.874837,-596.720442],[698.431183,-597.389393],[706.071176,-597.662382],[713.784394,-597.530413],[721.560414,-596.984487],[729.296733,-596.027864],[736.892142,-594.677015],[744.338126,-592.942774],[751.626173,-590.835972],[758.747770,-588.367438],[765.694402,-585.548006],[772.457558,-582.388506],[779.028723,-578.899769],[785.399385,-575.092627],[791.561030,-570.977911],[797.505145,-566.566453],[803.223218,-561.869083],[808.706734,-556.896633],[813.947181,-551.659934],[818.936045,-546.169818],[823.664814,-540.437116],[828.124973,-534.472658],[832.308010,-528.287277],[836.205412,-521.891804],[839.808666,-515.297069],[843.109257,-508.513905],[846.098674,-501.553143],[848.768402,-494.425613],[851.109929,-487.142147],[853.114742,-479.713577],[854.774327,-472.150734],[856.080170,-464.464448],[857.023760,-456.665552],[857.596582,-448.764876],[857.790124,-440.773252],[857.595872,-432.701512],[857.005314,-424.560485]]);
  }
}

module poly_path3849(h)
{
  scale([25.4/90, -25.4/90, 1]) union()
  {
    linear_extrude(height=h)
      polygon([[60.607414,-172.509597],[87.119646,-177.934145],[112.428375,-182.821307],[136.567629,-187.137688],[159.571433,-190.849894],[181.473812,-193.924528],[202.308794,-196.328195],[222.110403,-198.027499],[240.912667,-198.989046],[258.749610,-199.179439],[275.655260,-198.565284],[291.663641,-197.113184],[306.808780,-194.789744],[321.124704,-191.561569],[334.645437,-187.395263],[347.405007,-182.257431],[353.509988,-179.313757],[359.437439,-176.114677],[365.191611,-172.656019],[370.776758,-168.933606],[376.197134,-164.943266],[381.456992,-160.680823],[386.560585,-156.142102],[391.512166,-151.322931],[396.315989,-146.219133],[400.976306,-140.826535],[409.883438,-129.158240],[418.267589,-116.284651],[426.162783,-102.172371],[433.603048,-86.788006],[440.622409,-70.098160],[447.254892,-52.069437],[453.534523,-32.668443],[459.495329,-11.861781],[465.171335,10.383945],[470.596567,34.102128],[475.805051,59.326166],[480.830814,86.089453],[488.227711,126.245631],[495.494605,163.880399],[509.410233,231.997888],[533.171823,342.509934],[542.105198,386.553213],[545.635401,406.132326],[548.465234,424.220479],[550.537658,440.920720],[551.795637,456.336092],[552.182134,470.569642],[551.640114,483.724414],[550.112538,495.903453],[548.961343,501.659275],[547.542370,507.209805],[545.848490,512.567924],[543.872574,517.746514],[541.607491,522.758455],[539.046112,527.616626],[536.181308,532.333910],[533.005949,536.923186],[529.512905,541.397336],[525.695047,545.769240],[517.056369,554.257831],[507.032879,562.492006],[495.567540,570.574809],[482.603316,578.609286],[468.083169,586.698482],[451.950063,594.945442],[434.146961,603.453210],[414.616827,612.324833],[370.147314,631.571823],[346.605661,641.318626],[322.973113,650.574821],[299.292024,659.267116],[275.604748,667.322221],[251.953638,674.666847],[228.381049,681.227701],[204.929333,686.931495],[181.640845,691.704938],[158.557938,695.474739],[135.722967,698.167608],[113.178285,699.710255],[102.028037,700.027341],[90.966245,700.029389],[79.998202,699.707235],[69.129202,699.051720],[58.364539,698.053681],[47.709509,696.703958],[37.169404,694.993389],[26.749520,692.912812],[16.455150,690.453067],[6.291589,687.604993],[-3.735870,684.359427],[-13.621931,680.707208],[-23.361301,676.639177],[-32.948685,672.146170],[-42.378790,667.219026],[-51.646321,661.848586],[-60.745983,656.025686],[-69.672483,649.741166],[-78.420527,642.985865],[-86.984819,635.750621],[-95.360067,628.026273],[-103.540975,619.803660],[-111.522250,611.073620],[-119.298596,601.826992],[-126.864721,592.054615],[-134.215330,581.747328],[-141.345129,570.895968],[-148.248822,559.491376],[-154.921117,547.524389],[-161.356719,534.985846],[-167.550334,521.866587],[-173.496667,508.157449],[-179.190424,493.849272],[-184.626311,478.932894],[-189.799035,463.399154],[-194.703300,447.238890],[-199.333812,430.442941],[-203.685277,413.002147],[-207.752402,394.907345],[-211.529891,376.149375],[-215.012450,356.719074],[-218.194786,336.607283],[-223.904198,296.924637],[-228.896398,259.641350],[-233.150063,224.670859],[-236.643869,191.926600],[-239.356492,161.322010],[-241.266607,132.770526],[-242.352892,106.185585],[-242.594022,81.480622],[-241.968674,58.569074],[-240.455523,37.364379],[-238.033245,17.779973],[-234.680517,-0.270708],[-232.648570,-8.747953],[-230.376015,-16.874227],[-227.860185,-24.660352],[-225.098415,-32.117148],[-222.088039,-39.255435],[-218.826392,-46.086033],[-215.310809,-52.619763],[-211.538624,-58.867446],[-207.507171,-64.839902],[-203.213786,-70.547951],[-198.655802,-76.002414],[-193.830554,-81.214111],[-188.735377,-86.193862],[-183.367605,-90.952488],[-177.724572,-95.500810],[-171.803614,-99.849648],[-165.602064,-104.009822],[-159.117257,-107.992152],[-145.287212,-115.466565],[-130.292153,-122.359450],[-114.110757,-128.757370],[-96.721700,-134.746888],[-78.103658,-140.414568],[-58.235307,-145.846974],[-37.095324,-151.130668],[9.084836,-161.598175],[60.607414,-172.509597]]);
  }
}

module poly_path3855(h)
{
  scale([25.4/90, -25.4/90, 1]) union()
  {
    linear_extrude(height=h)
      polygon([[1016.506814,-419.785635],[1017.150657,-428.521207],[1017.462980,-437.297927],[1017.434590,-446.116476],[1017.056297,-454.977537],[1016.318909,-463.881793],[1015.213236,-472.829925],[1013.730086,-481.822616],[1011.860268,-490.860547],[1009.594592,-499.944401],[1006.923865,-509.074861],[1003.838897,-518.252609],[1000.330497,-527.478326],[996.389473,-536.752694],[992.006635,-546.076397],[987.172791,-555.450117],[981.878751,-564.874535],[976.115323,-574.350333],[969.873316,-583.878195],[963.143539,-593.458802],[955.916801,-603.092836],[948.183911,-612.780980],[939.935677,-622.523915],[931.162909,-632.322325],[921.856415,-642.176891],[912.007005,-652.088295],[901.605487,-662.057220],[890.642670,-672.084348],[879.109363,-682.170361],[866.996375,-692.315941],[854.294515,-702.521771],[840.994591,-712.788532],[827.087414,-723.116907],[804.914382,-738.332461],[783.797964,-753.620365],[763.706032,-768.966469],[744.606458,-784.356623],[726.467113,-799.776679],[709.255870,-815.212487],[692.940599,-830.649897],[677.489173,-846.074759],[662.869463,-861.472925],[649.049341,-876.830244],[635.996679,-892.132567],[623.679348,-907.365744],[612.065221,-922.515627],[601.122168,-937.568065],[590.818062,-952.508908],[581.120775,-967.324008],[571.998177,-981.999215],[563.418141,-996.520379],[555.348539,-1010.873351],[547.757243,-1025.043981],[533.881052,-1052.781618],[521.532543,-1079.620093],[510.454689,-1105.446210],[500.390465,-1130.146772],[482.274801,-1175.718450],[473.709308,-1196.363172],[465.129340,-1215.429555],[456.277871,-1232.804402],[451.670002,-1240.822126],[446.897874,-1248.374517],[441.929356,-1255.447427],[436.732322,-1262.026704],[431.274643,-1268.098201],[425.524191,-1273.647767],[419.448837,-1278.661252],[413.016454,-1283.124508],[406.194912,-1287.023385],[398.952084,-1290.343733],[391.255841,-1293.071402],[383.074055,-1295.192244],[374.374598,-1296.692108],[365.125342,-1297.556845],[355.294158,-1297.772306],[344.848918,-1297.324340],[333.757493,-1296.198800],[321.987756,-1294.381534],[309.507578,-1291.858393],[296.284831,-1288.615228],[282.287386,-1284.637890],[267.483116,-1279.912228],[251.839892,-1274.424093],[235.325586,-1268.159336],[217.908069,-1261.103808],[199.555214,-1253.243357],[176.708504,-1242.723231],[154.158186,-1231.364689],[131.913608,-1219.187677],[109.984120,-1206.212141],[88.379069,-1192.458025],[67.107805,-1177.945276],[46.179677,-1162.693838],[25.604033,-1146.723657],[5.390222,-1130.054678],[-14.452406,-1112.706848],[-33.914505,-1094.700110],[-52.986723,-1076.054411],[-71.659713,-1056.789696],[-89.924126,-1036.925910],[-107.770613,-1016.483000],[-125.189826,-995.480909],[-142.172414,-973.939584],[-158.709031,-951.878970],[-174.790326,-929.319013],[-190.406951,-906.279657],[-205.549558,-882.780849],[-220.208796,-858.842533],[-234.375319,-834.484656],[-248.039776,-809.727162],[-261.192820,-784.589996],[-273.825100,-759.093105],[-285.927269,-733.256434],[-297.489978,-707.099927],[-308.503877,-680.643532],[-318.959619,-653.907192],[-328.847854,-626.910853],[-338.159233,-599.674461],[-346.884407,-572.217961],[-355.014029,-544.561299],[-362.538748,-516.724420],[-369.449217,-488.727269],[-375.736086,-460.589791],[-381.390007,-432.331933],[-386.401631,-403.973639],[-390.761608,-375.534855],[-394.460591,-347.035527],[-397.489230,-318.495599],[-399.838177,-289.935018],[-401.498082,-261.373728],[-402.459598,-232.831675],[-402.713375,-204.328804],[-402.250064,-175.885061],[-401.060317,-147.520391],[-399.134784,-119.254740],[-396.464118,-91.108053],[-393.038968,-63.100275],[-388.849987,-35.251352],[-383.887826,-7.581229],[-378.143135,19.890148],[-371.606567,47.142834],[-364.268771,74.156884],[-356.120400,100.912352],[-347.152105,127.389292],[-337.354536,153.567761],[-326.718346,179.427811],[-315.234184,204.949497],[-302.892703,230.112875],[-289.684553,254.897999],[-275.600386,279.284923],[-246.661717,326.393563],[-217.946721,371.023729],[-189.455192,413.218851],[-161.186923,453.022355],[-147.136446,472.040822],[-133.141706,490.477671],[-119.202678,508.338329],[-105.319336,525.628226],[-91.491653,542.352790],[-77.719605,558.517450],[-64.003165,574.127633],[-50.342307,589.188769],[-36.737005,603.706287],[-23.187234,617.685614],[-9.692968,631.132179],[3.745820,644.051412],[17.129154,656.448739],[30.457061,668.329591],[43.729567,679.699394],[56.946697,690.563579],[70.108478,700.927574],[83.214935,710.796806],[96.266094,720.176705],[109.261981,729.072699],[122.202622,737.490217],[135.088043,745.434687],[147.918269,752.911538],[160.693326,759.926198],[173.413241,766.484095],[186.078038,772.590660],[198.687745,778.251319],[211.242386,783.471502],[223.741988,788.256636],[236.186576,792.612152],[248.576177,796.543476],[260.910816,800.056038],[273.190519,803.155266],[285.415311,805.846589],[297.585220,808.135435],[309.700270,810.027233],[321.760487,811.527411],[333.765898,812.641398],[345.716528,813.374623],[357.612403,813.732513],[369.453548,813.720498],[381.239991,813.344006],[392.971756,812.608466],[404.648869,811.519306],[416.271357,810.081954],[427.839244,808.301840],[439.352558,806.184391],[450.811323,803.735037],[462.215566,800.959206],[473.565313,797.862326],[484.860589,794.449825],[496.101420,790.727134],[507.287832,786.699679],[518.419851,782.372890],[540.520814,772.843023],[551.300467,767.582424],[561.652360,761.912508],[571.584338,755.846269],[581.104245,749.396707],[590.219925,742.576817],[598.939225,735.399598],[607.269988,727.878047],[615.220059,720.025161],[622.797283,711.853938],[630.009504,703.377374],[636.864568,694.608468],[643.370319,685.560216],[649.534602,676.245616],[655.365261,666.677665],[660.870142,656.869360],[666.057089,646.833699],[670.933946,636.583680],[675.508559,626.132298],[679.788772,615.492553],[683.782430,604.677440],[687.497377,593.699958],[690.941460,582.573104],[697.048406,559.923268],[702.166026,536.831911],[706.357079,513.403011],[709.684323,489.740548],[712.210514,465.948499],[713.998411,442.130843],[715.110771,418.391560],[715.610353,394.834627],[715.559915,371.564024],[715.022214,348.683728],[714.060008,326.297719],[712.736056,304.509975],[711.113114,283.424475],[707.221294,243.776120],[702.886612,208.184484],[698.611131,177.481395],[694.896914,152.498683],[694.928263,143.878213],[695.400404,135.268320],[696.299679,126.668000],[697.612429,118.076245],[699.324998,109.492050],[701.423728,100.914411],[703.894961,92.342320],[706.725039,83.774774],[709.900305,75.210765],[713.407101,66.649288],[721.360653,49.529910],[730.476434,32.408593],[740.645184,15.277293],[751.757640,-1.872034],[763.704543,-19.047435],[776.376630,-36.256953],[789.664641,-53.508634],[803.459314,-70.810523],[817.651390,-88.170664],[846.790701,-123.097885],[876.208486,-158.354655],[905.030657,-194.005334],[918.945234,-211.998502],[932.383124,-230.114282],[945.235066,-248.360719],[957.391800,-266.745858],[968.744063,-285.277745],[979.182595,-303.964422],[988.598135,-322.813937],[996.881421,-341.834334],[1000.564325,-351.411126],[1003.923193,-361.033657],[1006.944368,-370.702930],[1009.614190,-380.419951],[1011.919004,-390.185727],[1013.845151,-400.001263],[1015.378973,-409.867564],[1016.506814,-419.785635]]);
  }
}


fudge = 0.1;
max_h = 70;
rest_h = 2;
custom_scale = 0.225;
ref_x=130;
ref_y=94;
ref_z=max_h;
ref_pad=10;
pad = 0.1;
padd = pad*2;
angle=atan(ref_z/ref_y);
squish=ref_y/(sqrt(ref_z*ref_z+ref_y*ref_y));
echo( squish );
rot = -17;

//translate([-ref_x/2,-ref_y/2,0])
//#cube([ref_x,ref_y,ref_z]);

//scale([1,squish,1])
//difference() {
    //poly_path3069(max_h);
    //translate([0,ref_y/2,ref_z])
    //rotate([angle,0,0])
    //translate([-ref_x/2-ref_pad/2,-ref_y*2+ref_pad/2,0])
    //#cube([ref_x+ref_pad,ref_y*2+ref_pad,ref_z+ref_pad]);
//}

mirror([1,0,0])
scale([squish,1,1])
difference() {
    union() {
        //holder
        difference() {
            rotate([0,0,rot])
            scale([custom_scale,custom_scale,1])
            poly_path3855(max_h);
            translate([-24,-ref_x/2,0])
            rotate([0,-angle,0])
            cube([ref_x+ref_pad,ref_y*2+ref_pad,ref_z+ref_pad]);
        }
        //hand rest
        rotate([0,0,rot])
        scale([custom_scale,custom_scale,1])
        poly_path3071(rest_h);
    }

    //power button
    rotate([0,0,rot])
    translate([0,0,-pad])
    scale([custom_scale,custom_scale,1])
    poly_path3069(max_h+padd);
    //ball hole
    rotate([0,-angle,0])
    translate([21,-14,-40])
    scale([custom_scale,custom_scale,1])
    scale([1/squish,1,1])
    #poly_path3853(max_h+padd);
    rotate([0,0,rot])
    //battery
    translate([0,0,-pad])
    scale([custom_scale,custom_scale,1])
    poly_path3849(max_h+padd);

}
