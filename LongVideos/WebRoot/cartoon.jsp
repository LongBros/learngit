<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.longbro.bean.Category"%>
<%@page import="utils.Movie"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Element"%>
<%@page import="org.jsoup.select.Elements"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String cate=request.getParameter("cate");//类型
String cpage=request.getParameter("page");
int pageI=1;
String cateI="";
String cateName="";//分类名，主要用于title中，方便百度蜘蛛爬取时带上分类名
//类型
if("other".equals(cate)){
	cateI="other";
	cateName="其他";
}else if("all".equals(cate)||StringUtils.isEmpty(cate)){
	cateI="all";
	cateName="全部";
}else{
	cateI=cate;
	cateName=Movie.getCatgoryNameById("cartoon", cateI);
	/* ArrayList<String> arr1=new ArrayList<String>();
	for(int i=100;i<140;i++){
		String t=i+"";
		arr1.add(t);
	}
	//实现直接进入为全部，点击页类型进入，为类型的
	for(int i=0;i<arr1.size();i++){
		if((arr1.get(i)).equals(cate)){
			cateI=arr1.get(i);
			cateName=Movie.getCatgoryNameById("cartoon", cateI);
			break;//
		}
		if(i==(arr1.size()-1)){//到循环的最后一个，还没有与之相 匹配的页码，说明是直接进去的
			cateI="all";
			cateName="全部";
		}
	}		 */
}
if(StringUtils.isEmpty(cpage)){
	pageI=1;
}else{
	pageI=Integer.parseInt(cpage);
}
/* //将所有的页码添加至数组链表
ArrayList<String> arr=new ArrayList<String>();
for(int i=1;i<24;i++){
	String t=i+"";
	arr.add(t);
}
//实现直接进入为第一页，点击页码进入，为页码的
for(int i=0;i<arr.size();i++){
	if((arr.get(i)).equals(cpage)){//如果有参数，且与数组中参数向同，则将数组中该元素定位页码，转为整型
		pageI=Integer.parseInt(arr.get(i));
		break;//
	}
	if(i==(arr.size()-1)){//到循环的最后一个，还没有与之相 匹配的页码，说明是直接进去的
		pageI=1;
	}
} */
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>    
    <title>动漫-<%=cateName%>(分类)-553影院</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="shortcut icon" href="/images/util/logo2.png" type="image/x-icon">
	<link rel="stylesheet" type="text/css" href="css/layui.css">
	<link rel="stylesheet" type="text/css" href="css/mainpage.css">
  </head>
  <body>
		<ul class="layui-nav layui-bg-green">
		  <li class="layui-nav-item"><a href="/MainPage">旧版-LongBro影院</a></li>
		  <li class="layui-nav-item"><a href="/index.jsp">首页</a></li>
		  <li class="layui-nav-item"><a href="/series.jsp">电视剧</a></li>
		  <li class="layui-nav-item"><a href="/movie.jsp">电影</a></li>
		  <li class="layui-nav-item"><a href="/variety.jsp">综艺</a></li>
		  <li class="layui-nav-item layui-this"><a href="/cartoon.jsp">动漫</a></li>
		  <li class="layui-nav-item">
		    <a href="javascript:;">其他</a>
		    <dl class="layui-nav-child">
		      <dd><a href="http://www.longqcloud.cn/leaveword.jsp" target="_blank">留言</a></dd>
		      <dd><a href="http://www.longqcloud.cn/msgboard.jsp" target="_blank">每日一句</a></dd>
		      <dd><a href="http://www.longqcloud.cn/sponsor/showSponsor.jsp" target="_blank">赞助记录</a></dd>
		    </dl>
		  </li>
		  <li class="layui-nav-item"><a href="http://www.longqcloud.cn" target="_blank">LongBro博客</a></li>
		</ul>
		<ul class="layui-nav layui-layout-right layui-bg-green" >
	      <li class="layui-nav-item">
	      	<form action="/search.jsp" method="post" target="_blank">
		      <input type="text" class="input"  placeholder="尽情搜吧" name="v_name">
		      <input type="submit" class="search" value='搜索'>
		  	</form>
	      </li>
	    </ul>
	<%
	out.write("<div class='cate'>");
		out.write("类型:&nbsp;");
		ArrayList<Category> cs=Movie.getCate("dongman");//根据分类获取分类下的类型
		for(Category c:cs){
			String cat=c.getId();
			String name=c.getName();
			String url="";
			if(name.contains(cateName)){//因name中可能含有空格，故不用equal
				url="<a href='/cartoon.jsp?cate="+cat+"&page=1'><font color='orange'>"+name+"</font></a>&nbsp;";
			}else{
				url="<a href='/cartoon.jsp?cate="+cat+"&page=1'>"+name+"</a>&nbsp;";
			}
			out.write(url);
		}
		out.write("</div>");	
		String main="https://www.360kan.com";
        String url="https://www.360kan.com/dongman/list.php?rank=rankhot&cat="+cateI+"&area=all&year=all&pageno="+pageI;
		Document doc=Jsoup.connect(url).get();
		Elements plays=doc.getElementsByClass("js-tongjic"); 
		for(Element play: plays){
			String p=play.toString();
			String[] s=p.split(">");//0视频链接，2图片链接，5更新情况，11视频名
		    String hr=s[0]+">";
		    String hre=main+hr.substring(hr.indexOf("href=")+6, hr.indexOf("\">"));
			String sr=s[2]+">";
			String src=sr.substring(sr.indexOf("src=")+5, sr.indexOf("\">"));

			String update,name;
			update=s[5].substring(0, s[5].indexOf("</span"));					  
			name=s[11].substring(0, s[11].indexOf("</span"));	
			if(name.length()>11){
				name=name.substring(0,11)+"...";
			}
			//从href网页源码中获取其他信息，如视频的详情，剧集，等等，然后传入播放界面并显示
			//或者只将hre传入player.jsp，在其里面进行这些信息的爬取操作	
			out.write("<div class='whole'><a href=\"/player.jsp?type=dongman&url="+hre+"\" target='_blank'>"
			  		+ "<img src='"+src+"' title='"+name+"' alt='"+src+"'>"
			  				+ "<span>"+name+"</span><br><p>"+update+"</p></a></div>");
		   }
			out.write("<center><div class='page'>");
			if(pageI>1){//当前页码大于1，显示上一页按钮
				out.write("<a  href=\"/cartoon.jsp?cate="+cate+"&page="+(pageI-1)+"\">上</a>");
			}
			if(pageI>24-6){//当前页码大于总页码-6，输出后六页
			    for(int j=24-5;j<=24;j++){
			        if(j==pageI){
			             out.write("<current><a>"+j+"</a></current>");     
			        }else{
			             out.write("<a href=\"/cartoon.jsp?cate="+cate+"&page="+j+"\">"+j+"</a>"); 
			        }
			    }
			}else{//当前页码小于总页码-6，输出当前页码后的六页
			    for(int j=pageI;j<pageI+6;j++){
			    	if(j==pageI){
			             out.write("<current><a>"+j+"</a></current>");     
			        }else{
			             out.write("<a href=\"/cartoon.jsp?cate="+cate+"&page="+j+"\">"+j+"</a>"); 
			        }
			    }
			}
			if(pageI<24){//当前页码小于24，显示下一页按钮
				out.write("<a  href=\"/cartoon.jsp?cate="+cate+"&page="+(pageI+1)+"\">下</a>");
			}
			out.write("</div></center>");
	       %>
		<center><hr width='80%' height='5px'></center><br>
		<%@include file="/footer.jsp" %>
		<script src="layui.js" charset="utf-8"></script>
		<script>
		layui.use('element', function(){
		  var element = layui.element; //导航的hover效果、二级菜单等功能，需要依赖element模块
		  
		  //监听导航点击
		  element.on('nav(demo)', function(elem){
		    //console.log(elem)
		    layer.msg(elem.text());
		  });
		});
		</script> 
 </body>
</html>