<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../foreinclude/foreHander.jsp"%>
<%
    String basePath = request.getScheme()+"?/"+request.getServerName()+":"+request.getServerPort()+"/";
%>
<div class="page-section mb-50" style="margin-top: -100px">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <form action="#">
                    <div class="cart-table table-responsive mb-40">
                        <table class="table">
                            <thead>
                            <tr>
                                <th></th>
                                <th class="pro-thumbnail">图片</th>
                                <th class="pro-title">名称</th>
                                <th class="pro-price">单价</th>
                                <th class="pro-quantity">数量</th>
                                <th class="pro-subtotal">小计</th>
                                <th class="pro-remove">删除</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${ois}" var="oi">
                                <tr>
                                    <td><input style="width: 20px;height: 20px;margin-top: 23px" type="checkbox" name="crrent" onclick="dianji(this,${oi.number},${oi.id},${oi.product.price});"></td>
                                    <td class="pro-thumbnail">
                                        <img src="${pageContext.request.contextPath}/${oi.product.imageurl}" class="img-fluid" alt="Product">
                                    </td>
                                    <td class="pro-title">${oi.product.name}</td>
                                    <c:if test="${cst.status==0}"><td class="pro-price"><span>$${oi.product.price}</span></td></c:if>
                                    <c:if test="${cst.status==1}"><td class="pro-price"><span>$${oi.product.price*0.8}</span></td></c:if>
                                    <td class="pro-quantity"><div class="pro-qty"><input type="text" id="oiNumber${oi.id}" value="${oi.number}"></div></td>
                                    <c:if test="${cst.status==0}">
                                        <td class="pro-subtotal"><span id="xiaoji1">$${oi.number*oi.product.price}</span></td>
                                    </c:if>
                                    <c:if test="${cst.status==1}">
                                        <td class="pro-subtotal"><span id="xiaoji08">$${oi.number*oi.product.price*0.8}</span></td>
                                    </c:if>
                                    <td class="pro-remove"  id="delOrderItem${oi.id}"><a href="javascript:;" onclick="delOrderItem(${oi.id});"><i class="fa fa-trash-o"></i></a></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </form>
                <div class="row">
                    <div class="col-lg-12 col-12 d-flex">
                        <div class="cart-summary">
                            <div class="cart-summary-wrap">
                                <h4>购物车摘要</h4>
                                <p>数量小计 <span id="OisNum"></span></p>
                                <h2>总计(不含运费) <span id="OisTotal"></span></h2>
                            </div>
                            <div class="cart-summary-button">
                                <button class="update-btn" onclick="subMyOrder();">下单</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/jquery/2.0.0/jquery.min.js"></script>
<script type="text/javascript">
    var oiids = [];
    //总购买数量
    var totalNumb=0;
    //订单总价
    var totaljiage=0;
    function dianji(object,number,oiid,price){
        //订单项购买数量
        var num = $("#oiNumber"+oiid).val()*1;
        //保存选中的订单项的小计
        var currentTotaljg = 0;
        //保存商品具体价格
        var p=0;
        //判断是否是会员 进行折扣
        if(${cst.status==1}){
            p = price*0.8;
            $("xiaoji08").val(p*num);
        }else{
            p=price*1;
            $("xiaoji1").val(p*num);
        }
        //选中订单项
        if(object.checked==1){
            //获取当前订单项的购买商品数量
            num = $("#oiNumber"+oiid).val()*1;
            //当数量不一致时更新数据库
            if (num!==number){
                $.get("updateOrderItemNumber?id="+oiid+"&number="+num);
            }
            //获取下单数量 默认0
            totalNumb += num;
            //计算当前订单项小计
            currentTotaljg = num*p;
            totaljiage += currentTotaljg;
            //更新订单价格
            $("#OisTotal").text("$"+totaljiage);
            //更新下单的购买数量
            $("#OisNum").text(totalNumb);
            //添加订单项id
            oiids.push(oiid);
        }else{//撤销订单项
            num = $("#oiNumber"+oiid).val()*1;
            totalNumb -= num;
            currentTotaljg = num*p;
            totaljiage -= currentTotaljg;
            $("#OisTotal").text("$"+totaljiage);
            $("#OisNum").text(totalNumb);
            removeByValue(oiids,oiid);//这里突然没有js的remove方法，自定义一个
        }
    }
    function removeByValue(arr, val) {
        for(var i=0; i<arr.length; i++) {
            if(arr[i] == val) {
                arr.splice(i, 1);
                break;
            }
        }
    }
    //提交购物车订单
    function subMyOrder() {
        if(oiids.length==0){
            alert("请勾选要买的商品");
            return false;
        }
        window.location.href="/fore/forebuy?oiid="+oiids;
    }
    function delOrderItem(oiid) {
        $.get(
            "foreDelOrderItem",
            {"oiid":oiid},
            function (result) {
                if(result="success"){
                    $("#delOrderItem"+oiid).parent().remove();
                }else{
                    alert("登陆过期，请登录");
                }
            }
        );
    }
</script>

<%@ include file="../../foreinclude/foreFooter.jsp"%>
