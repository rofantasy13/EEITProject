<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>討論區</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.2.1.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
function DeleteItem(clicked_id) {
	var url = "<c:url value='/DeleteCartProduct?pId=" + clicked_id + "'/>";
	$.ajax({
		url : url,
		type : "get",
		success : function(data) {
			$("div.modal-body").html(data);
		}
	});
};

function CheckOutButton(){
	if(${empty shoppingCart.content}){
		alert("購物車內無商品");
		return;
	}else{
		location.href = "<c:url value='/CheckOut'/>";
	}
};

// function ShowArticle(id) {
// 		var precontent= "#PreContent" + id;
// 		var content= "#aContent" + id;
// 		var ShowArticle= ".ShowArticle" + id;
// 		var Reply="#Reply" + id;
// 		var CloseArticle = ".CloseArticle" + id;
// 		$(precontent).hide();
// 		$(content).show();
// 		$(ShowArticle).hide();
// 		$(CloseArticle).show();
// 		$(Reply).css('display','inline-block');
// };
// function CloseArticle(id) {
// 	var precontent= "#PreContent" + id;
// 	var content= "#aContent" + id;
// 	var ShowArticle= ".ShowArticle" + id;
// 	var Reply="#Reply" + id;
// 	var CloseArticle = ".CloseArticle" + id;
// 	$(precontent).show();
// 	$(content).hide();
// 	$(ShowArticle).show();
// 	$(CloseArticle).hide();
// 	$(Reply).hide();
// };
</script>
<style>
.PageButton {
	color: #20bf6b !important;
	text-transform: uppercase;
	background: #ffffff;
	padding: 10px;
	border: 4px solid #20bf6b !important;
	border-radius: 6px;
	display: inline-block;
	transition: all 0.3s ease 0s;
	text-decoration: none;
}

.PageButton:hover {
	color: #494949 !important;
	border-radius: 50px;
	border-color: #494949 !important;
	transition: all 0.3s ease 0s;
}
</style>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
		<div class="container">
			<a class="navbar-brand" href="<c:url value='/'/>">旅遊趣</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav"
				aria-controls="ftco-nav" aria-expanded="false" aria-label="Toggle navigation">
				<span class="oi oi-menu"></span> Menu
			</button>

			<div class="collapse navbar-collapse" id="ftco-nav">
				<ul class="navbar-nav ml-auto">
					<li class="nav-item active"><a href="<c:url value='/'/>" class="nav-link">Home</a></li>
					<li class="nav-item"><a href="<c:url value='/products/1'/>" class="nav-link">Products</a></li>
					<c:if test="${empty LoginOK}">
						<li class="nav-item"><a href="<c:url value='/login'/>" class="nav-link">Login</a></li>
						<li class="nav-item"><a href="<c:url value='/register/add'/>" class="nav-link">Register</a></li>
					</c:if>
					<c:if test="${!empty LoginOK}">
						<li class="nav-item"><a href="<c:url value='/UserDashboard'/>" class="nav-link">會員中心</a></li>
						<li class="nav-item"><a href="<c:url value='/logout'/>" class="nav-link">Logout</a></li>
					</c:if>
				</ul>
				<ul class="navbar-nav mr-right">
					<li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="#"
						id="navbarDropdown" role="button" data-toggle="modal" aria-haspopup="true"
						aria-expanded="false" data-target="#shoppingCartMenu">購物車</a> <!-- 						<div id="shoppingCartMenu" class="dropdown-menu" aria-labelledby="navbarDropdown"></div> -->
					</li>
				</ul>
			</div>
		</div>
	</nav>

	<!-- Modal -->
	<div class="modal fade" id="shoppingCartMenu" tabindex="-1" role="dialog"
		aria-labelledby="shoppingCartMenuTitle" aria-hidden="true" data-backdrop="false">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="shoppingCartMenuTitle">
						<c:choose>
							<c:when test="${!empty LoginOK}">
						${LoginOK.mName}的購物車
						</c:when>
							<c:otherwise>
						你的購物車
						</c:otherwise>
						</c:choose>
					</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<c:if test="${empty shoppingCart.content }">
						<p style="text-align: center; margin-top: 10%">購物車內已無商品</p>
					</c:if>
					<c:forEach varStatus="vs" var="cart" items="${shoppingCart.content }">
						<img style="width: 80px; float: left; vertical-align: center; margin-right: 1%;"
							src="<c:url value='/showPic/${cart.value.pId}'/>">
						<p style="line-height: 10px">${cart.value.pName}</p>
						<span style="line-height: 5px">數量:${cart.value.iQty} 價格:${cart.value.pPrice}</span>
						<span><input class="btn btn-outline-danger" id="${cart.value.pId}" type="button"
								onclick="DeleteItem(this.id)" value="刪除" /> </span>
						<c:choose>
							<c:when test="${vs.last}">
							</c:when>
							<c:otherwise>
								<hr>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-dark" data-dismiss="modal">繼續購物</button>
					<button type="button" onclick="CheckOutButton()" class="btn btn-success">結帳</button>
				</div>
			</div>
		</div>
	</div>
	<div style="margin: 5% auto; width: 1205px;">
		<button class="btn btn-primary" type="button" data-toggle="collapse" data-target="#NewArticle"
			aria-expanded="false" aria-controls="NewArticle">發表新文章</button>
		<div class="collapse" id="NewArticle">
			<div class="card card-body">
				<!-- 			發表文章表單 -->
				<form:form method="POST" action="${pageContext.request.contextPath}/PostArticle"
					modelAttribute="ArticleBean">
					<div class="form-group row">
						<label for="aTitle" class="col-sm-2 col-form-label">標題</label>
						<div class="col-sm-10">
							<form:input type="text" id="aTitle" class="form-control" path="aTitle" placeholder="標題" />
						</div>
					</div>
					<div class="form-group row">
						<label for="arContent" class="col-sm-2 col-form-label">內文</label>
						<div class="col-sm-10">
							<textarea rows="5" class="form-control" id="arContent" name="arContent" placeholder="文章內容"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-10">
							<button type="submit" class="btn btn-primary">送出文章</button>
						</div>
					</div>
					<form:input type="hidden" path="aDisplay" value="1" />
				</form:form>
				<!-- 	發表文章表單結尾	 -->


			</div>
		</div>
	</div>
	<div style="width: 1205px; margin: 0% auto;">
		<c:if test="${!empty ArticleList}">
			<c:forEach varStatus="vs" var="ArticleBean" items="${ArticleList}">
				<div style="width: 600px; display: inline-block;">
					<div class="container mt-5 border">
						<div class="row">
							<div class="col-md-3 border">
								<img style="margin: 6% 0" width="100%" src="<c:url value='/showmPic/${ArticleBean.mId}'/>">
								<div class="row">
									<div style="text-align: center;" class="col-md-12">good button</div>
								</div>
							</div>
							<div class="col-md-9">
								<div class="row">
									<div class="col-md-7">
										<p style="font-size: 20px;">${ArticleBean.aTitle}</p>

									</div>
									<div style="text-align: right; font-size: 15px;" class="col-md-5">
										<div class="row">
											<div class="col-md-2"></div>
											<div class="col-md-2">
											</div>
											<div class="col-md-8">
												<span>${ArticleBean.mName}</span>
											</div>
										</div>
										<div class="row">
											<div class="col-ml-3"></div>
											<div class="col-mr-9">

											</div>
										</div>
									</div>
								</div>
								<div class="row border-bottom">
									<div class="col-md-8"></div>
								</div>
								<div style="height: 80px;" id="PreContent${ArticleBean.aId}" class="col-md-9">
									<p style="font-size: 15px;">${ArticleBean.aPreContent}</p>
								</div>
								<div style="display: none;" id="aContent${ArticleBean.aId}" class="col-md-9">
									<span style="font-size: 15px;">${ArticleBean.aContent}</span>
								</div>
								<a href="<c:url value='/ShowArticle/${ArticleBean.aId}'/>" class="ShowArticle${ArticleBean.aId}"
									id="${ArticleBean.aId}"><span>顯示文章</span></a> 
<!-- 									<a style="display: none" href="#" -->
<%-- 									onclick="CloseArticle(this.id)" class="CloseArticle${ArticleBean.aId}" --%>
<%-- 									id="${ArticleBean.aId}"><span>收起文章</span></a> --%>
								<p style="font-size: 15px; text-align: right;">${ArticleBean.aAddTime}</p>
							</div>
						</div>
					</div>
					<!-- 					文章回覆 -->
<%-- 					<div id="Reply${ArticleBean.aId}" style="display: none; width: 600px;" class="container mt-1"> --%>
<!-- 						<div class="row"> -->
<!-- 							<div class="col-md-3"></div> -->
<!-- 							<div class="col-md-9 border"> -->
<!-- 								<div class="row"> -->
<!-- 									<div class="col-md-3 border"> -->
<%-- 										<img style="margin: 6% 0" width="100%" src="<c:url value='/showmPic/${ArticleBean.mId}'/>"> --%>
<!-- 										<div class="row"> -->
<!-- 											<div style="text-align: center;" class="col-md-12">good button</div> -->
<!-- 										</div> -->
<!-- 									</div> -->
<!-- 									<div class="col-md-9"> -->
<!-- 										<div class="row"> -->
<!-- 											<div class="col-md-5"> -->
<%-- 												<span>用戶:${ArticleBean.mName}</span> --%>
<!-- 											</div> -->
<!-- 											<div style="text-align: right; font-size: 15px;" class="col-md-7"> -->
<!-- 												<div class="row"> -->
<!-- 													<div class="col-md-4"></div> -->
<!-- 													<div class="col-md-4"> -->
<%-- 														<c:if test="${ArticleBean.mId==LoginOK.mId}"> --%>
<!-- 															<a href="#">修改</a> -->
<%-- 														</c:if> --%>
<!-- 													</div> -->
<!-- 													<div class="col-md-4"> -->
<!-- 														<a href="#">回覆</a> -->
<!-- 													</div> -->
<!-- 												</div> -->
<!-- 												<div class="row"> -->
<!-- 													<div class="col-ml-3"></div> -->
<!-- 													<div class="col-mr-9"></div> -->
<!-- 												</div> -->
<!-- 											</div> -->
<!-- 										</div> -->
<!-- 										<div class="row border-bottom"> -->
<!-- 											<div class="col-md-8"></div> -->
<!-- 										</div> -->
<%-- 										<div id="aContent${ArticleBean.aId}" class="col-md-9"> --%>
<%-- 											<span style="font-size: 15px;">${ArticleBean.aContent}</span> --%>
<!-- 										</div> -->
<%-- 										<p style="font-size: 15px; text-align: right;">${ArticleBean.aAddTime}</p> --%>
<!-- 									</div> -->
<!-- 								</div> -->
<!-- 							</div> -->
<!-- 						</div> -->
<!-- 					</div> -->
					<!-- 					文章回覆 -->
				</div>

			</c:forEach>
			<div style="width: 300px; margin: 3% 0;">
				<c:if test="${pageNo>1}">
					<a class="PageButton" href="<c:url value='/ForumIndex/1'/>"> 第一頁</a>
				</c:if>
				<c:if test="${pageNo>1}">
					<a class="PageButton" href="<c:url value='/ForumIndex/${pageNo-1}'/>"> 上一頁</a>
				</c:if>
				<c:if test="${pageNo!=totalPages&&!empty ArticleList}">
					<a class="PageButton" href="<c:url value='/ForumIndex/${pageNo+1}'/>"> 下一頁</a>
				</c:if>
			</div>
		</c:if>
	</div>
</body>
</html>