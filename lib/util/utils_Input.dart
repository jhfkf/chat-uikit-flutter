import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
///输入框组件封装 文件

//const _regExp=r"^[\u4E00-\u9FA5A-Za-z0-9_]+$";忽略特殊字符
// const _regExp=r"^[Za-z0-9_]+$";只能输入数字和小写字母
// const _regExp=r"^[ZA-ZZa-z0-9_]+$"; 只能输入数字和字母


/// 回收键盘
void keyboardBack() {
  if (Get.focusScope?.hasPrimaryFocus == true) {
    Get.focusScope?.unfocus();
  }
}

class TbrInput extends StatefulWidget {
  ///输入框控制器
  final TextEditingController? controller;
  ///输入框无内容时显示的提示语
  final String? hintText;
  ///是否可以输入
  final bool? enabled;
  ///输入框点击事件
  final void Function()? onTap;
  ///输入框值改变回调
  final ValueChanged<String>? onChanged;
  ///输入值验证规则-正则表达式字符串
  final String? regExp;
  ///最大可输入行数
  final int? maxLines;
  ///是否可以填充背景色
  final bool? filled;
  ///背景色
  final Color? fillColor;
  ///焦点
  final FocusNode? focusNode;
  ///是否自动获取焦点
  final bool autofocus;
  ///输入框最大可输入长度
  final int maxLength;
  ///内容内间距
  final EdgeInsetsGeometry? contentPadding;
  ///内容文字样式
  final TextStyle? inputStyle;
  ///提示文字样式
  final TextStyle? hintStyle;
  ///输入边框样式
  final InputBorder? border;
  ///默认状态下输入边框样式
  final InputBorder? enabledBorder;
  ///焦点状态下输入边框样式
  final InputBorder? focusedBorder;
  ///提交回调
  final ValueChanged<String>? onSubmitted;
  ///文本对齐样式
  final TextAlign textAlign;
  ///键盘样式
  final TextInputType? keyboardType;
  ///回车键样式
  final TextInputAction? textInputAction;
  ///键盘done事件
  final void Function()? onEditingComplete;

  final bool obscureText;
  TbrInput({
    Key? key,
    this.controller,
    this.focusNode,
    this.enabled,
    this.onTap,
    this.hintText,
    this.onChanged,
    this.regExp,
    this.maxLines,
    this.autofocus = false,
    this.filled,
    this.fillColor,
    this.maxLength = 99,
    this.contentPadding,
    this.inputStyle,
    this.hintStyle,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.onSubmitted,
    this.textAlign = TextAlign.left,
    this.keyboardType,
    this.textInputAction,
    this.onEditingComplete,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<TbrInput> {

  //输入框文本
  String _inputText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///初始化输入框内容
    // widget.controller = TextEditingController.fromValue(
    //   TextEditingValue(
    //     text: _inputText,
    //     selection: TextSelection.fromPosition(
    //       TextPosition(affinity: TextAffinity.downstream, offset: _inputText.length),
    //     ),
    //   ),
    // );
  }


  @override
  Widget build(BuildContext context) {
    return TextField(
      style: widget.inputStyle??const TextStyle(
        fontSize: 15,
        color: Colors.black,
        height: 1.4,
      ),
      textAlignVertical: TextAlignVertical.center,
      onTap: widget.onTap,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      minLines: 1,
      maxLines: widget.maxLines??1,
      controller: widget.controller,
      autofocus: widget.autofocus,
      textAlign: widget.textAlign,
      textInputAction: widget.textInputAction,
      onEditingComplete: widget.onEditingComplete,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        counterText: '',  // 去除输入框底部的字符计数
        fillColor: widget.fillColor,
        filled: widget.filled,
        border: widget.border??const OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: widget.enabledBorder,
        focusedBorder: widget.focusedBorder,
        hintText: widget.hintText ?? '',
        isCollapsed: true,
        hintStyle: widget.hintStyle ?? const TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
        contentPadding: widget.contentPadding??const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      ),
      inputFormatters: [
        //输入规则
        FilteringTextInputFormatter.allow(RegExp(widget.regExp??'[^@]')),
        //限制输入长度
        LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      onSubmitted: widget.onSubmitted,
      onChanged: (value) {
        _inputText = value;
        if(widget.onChanged!=null){
          widget.onChanged!(value);
        }
        setState(() {});
      },
      keyboardType: widget.keyboardType,
    );
  }
}