// // ignore_for_file: unused_import

// import 'package:flutterflow_ui/flutterflow_ui.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// // import 'sign_up_model.dart';
// // export 'sign_up_model.dart';

// class SignUpWidget extends StatefulWidget {
//   const SignUpWidget({Key? key}) : super(key: key);

//   @override
//   _SignUpWidgetState createState() => _SignUpWidgetState();
// }

// class _SignUpWidgetState extends State<SignUpWidget>
//     with TickerProviderStateMixin {
//   // late SignUpModel _model;

//   // final scaffoldKey = GlobalKey<ScaffoldState>();

//   final animationsMap = {
//     'containerOnPageLoadAnimation': AnimationInfo(
//       trigger: AnimationTrigger.onPageLoad,
//       effects: [
//         VisibilityEffect(duration: 1.ms),
//         FadeEffect(
//           curve: Curves.easeInOut,
//           delay: 0.ms,
//           duration: 300.ms,
//           begin: 0,
//           end: 1,
//         ),
//         MoveEffect(
//           curve: Curves.easeInOut,
//           delay: 0.ms,
//           duration: 300.ms,
//           begin: const Offset(0, 140),
//           end: const Offset(0, 0),
//         ),
//         ScaleEffect(
//           curve: Curves.easeInOut,
//           delay: 0.ms,
//           duration: 300.ms,
//           begin: const Offset(0.9, 0.9),
//           end: const Offset(1, 1),
//         ),
//         TiltEffect(
//           curve: Curves.easeInOut,
//           delay: 0.ms,
//           duration: 300.ms,
//           begin: const Offset(-0.349, 0),
//           end: const Offset(0, 0),
//         ),
//       ],
//     ),
//   };

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _model = createModel(context, () => SignUpModel());

//   //   _model.emailAddressController ??= TextEditingController();
//   //   _model.emailAddressFocusNode ??= FocusNode();

//   //   _model.userNameController ??= TextEditingController();
//   //   _model.userNameFocusNode ??= FocusNode();

//   //   _model.passwordController ??= TextEditingController();
//   //   _model.passwordFocusNode ??= FocusNode();

//   //   WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
//   // }

//   // @override
//   // void dispose() {
//   //   _model.dispose();

//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     if (isiOS) {
//       SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle(
//           statusBarBrightness: Theme.of(context).brightness,
//           systemStatusBarContrastEnforced: true,
//         ),
//       );
//     }

//     return GestureDetector(
//       onTap: () => unfocusNode.canRequestFocus
//           ? FocusScope.of(context).requestFocus(unfocusNode)
//           : FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         // key: scaffoldKey,
//         backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
//         body: Row(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Expanded(
//               flex: 6,
//               child: Container(
//                 width: 100,
//                 height: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       FlutterFlowTheme.of(context).primary,
//                       FlutterFlowTheme.of(context).tertiary
//                     ],
//                     stops: const [0, 1],
//                     begin: const AlignmentDirectional(0.87, -1),
//                     end: const AlignmentDirectional(-0.87, 1),
//                   ),
//                 ),
//                 alignment: const AlignmentDirectional(0.00, -1.00),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 32),
//                         child: Container(
//                           width: 200,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           alignment: const AlignmentDirectional(0.00, 0.00),
//                           child: Text(
//                             'App Name',
//                             style: FlutterFlowTheme.of(context)
//                                 .displaySmall
//                                 .override(
//                                   fontFamily: 'Sora',
//                                   color: Colors.white,
//                                 ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
//                         child: Container(
//                           width: double.infinity,
//                           constraints: const BoxConstraints(
//                             maxWidth: 570,
//                           ),
//                           decoration: BoxDecoration(
//                             color: FlutterFlowTheme.of(context)
//                                 .secondaryBackground,
//                             boxShadow: const [
//                               BoxShadow(
//                                 blurRadius: 4,
//                                 color: Color(0x33000000),
//                                 offset: Offset(0, 2),
//                               )
//                             ],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Align(
//                             alignment: const AlignmentDirectional(0.00, 0.00),
//                             child: Padding(
//                               padding: const EdgeInsetsDirectional.fromSTEB(
//                                   32, 32, 32, 32),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.max,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Get Started',
//                                     textAlign: TextAlign.center,
//                                     style: FlutterFlowTheme.of(context)
//                                         .displaySmall,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsetsDirectional.fromSTEB(
//                                         0, 12, 0, 24),
//                                     child: Text(
//                                       'Let\'s get started by filling out the form below.',
//                                       textAlign: TextAlign.center,
//                                       style: FlutterFlowTheme.of(context)
//                                           .labelLarge,
//                                     ),
//                                   ),
//                                   Container(
//                                     width: 120,
//                                     height: 120,
//                                     clipBehavior: Clip.antiAlias,
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Image.network(
//                                       'https://picsum.photos/seed/868/600',
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsetsDirectional.fromSTEB(
//                                         0, 0, 0, 16),
//                                     child: Container(
//                                       width: double.infinity,
//                                       child: TextFormField(
//                                         controller:
//                                             emailAddressController,
//                                         focusNode: emailAddressFocusNode,
//                                         autofocus: true,
//                                         autofillHints: const [AutofillHints.email],
//                                         obscureText: false,
//                                         decoration: InputDecoration(
//                                           labelText: 'Email',
//                                           labelStyle:
//                                               FlutterFlowTheme.of(context)
//                                                   .labelLarge,
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .primaryBackground,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .primary,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           errorBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .alternate,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           focusedErrorBorder:
//                                               OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .alternate,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           filled: true,
//                                           fillColor:
//                                               FlutterFlowTheme.of(context)
//                                                   .primaryBackground,
//                                         ),
//                                         style: FlutterFlowTheme.of(context)
//                                             .bodyLarge,
//                                         keyboardType:
//                                             TextInputType.emailAddress,
//                                         validator: emailAddressControllerValidator
//                                             .asValidator(context),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsetsDirectional.fromSTEB(
//                                         0, 0, 0, 16),
//                                     child: Container(
//                                       width: double.infinity,
//                                       child: TextFormField(
//                                         controller: userNameController,
//                                         focusNode: userNameFocusNode,
//                                         autofocus: true,
//                                         autofillHints: const [AutofillHints.name],
//                                         textCapitalization:
//                                             TextCapitalization.words,
//                                         obscureText: false,
//                                         decoration: InputDecoration(
//                                           labelText: 'Username',
//                                           labelStyle:
//                                               FlutterFlowTheme.of(context)
//                                                   .labelLarge,
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .primaryBackground,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .primary,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           errorBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .alternate,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           focusedErrorBorder:
//                                               OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .alternate,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           filled: true,
//                                           fillColor:
//                                               FlutterFlowTheme.of(context)
//                                                   .primaryBackground,
//                                         ),
//                                         style: FlutterFlowTheme.of(context)
//                                             .bodyLarge,
//                                         keyboardType: TextInputType.name,
//                                         validator:userNameControllerValidator
//                                             .asValidator(context),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsetsDirectional.fromSTEB(
//                                         0, 0, 0, 16),
//                                     child: Container(
//                                       width: double.infinity,
//                                       child: TextFormField(
//                                         controller: passwordController,
//                                         focusNode: passwordFocusNode,
//                                         autofocus: true,
//                                         autofillHints: const [AutofillHints.password],
//                                         obscureText: !_model.passwordVisibility,
//                                         decoration: InputDecoration(
//                                           labelText: 'Password',
//                                           labelStyle:
//                                               FlutterFlowTheme.of(context)
//                                                   .labelLarge,
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .primaryBackground,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .primary,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           errorBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .error,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           focusedErrorBorder:
//                                               OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .error,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           filled: true,
//                                           fillColor:
//                                               FlutterFlowTheme.of(context)
//                                                   .primaryBackground,
//                                           suffixIcon: InkWell(
//                                             onTap: () => setState(
//                                               () => passwordVisibility =
//                                                   !passwordVisibility,
//                                             ),
//                                             focusNode:
//                                                 FocusNode(skipTraversal: true),
//                                             child: Icon(
//                                               passwordVisibility
//                                                   ? Icons.visibility_outlined
//                                                   : Icons
//                                                       .visibility_off_outlined,
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .secondaryText,
//                                               size: 24,
//                                             ),
//                                           ),
//                                         ),
//                                         style: FlutterFlowTheme.of(context)
//                                             .bodyLarge,
//                                         validator: passwordControllerValidator
//                                             .asValidator(context),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsetsDirectional.fromSTEB(
//                                         0, 0, 0, 16),
//                                     child: FFButtonWidget(
//                                       onPressed: () async {
//                                         // GoRouter.of(context).prepareAuthEvent();

//                                         // final user =
//                                         //     await authManager.signInWithEmail(
//                                         //   context,
//                                         //   _model.emailAddressController.text,
//                                         //   _model.passwordController.text,
//                                         // );
//                                         // if (user == null) {
//                                         //   return;
//                                         // }

//                                         // context.goNamedAuth(
//                                         //     'profilePage', context.mounted);
//                                       },
//                                       text: 'Create Account',
//                                       options: FFButtonOptions(
//                                         width: double.infinity,
//                                         height: 44,
//                                         padding: const EdgeInsetsDirectional.fromSTEB(
//                                             0, 0, 0, 0),
//                                         iconPadding:
//                                             const EdgeInsetsDirectional.fromSTEB(
//                                                 0, 0, 0, 0),
//                                         color: FlutterFlowTheme.of(context)
//                                             .primary,
//                                         textStyle: FlutterFlowTheme.of(context)
//                                             .titleSmall
//                                             .override(
//                                               fontFamily: 'Inter',
//                                               color: Colors.white,
//                                             ),
//                                         elevation: 3,
//                                         borderSide: const BorderSide(
//                                           color: Colors.transparent,
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsetsDirectional.fromSTEB(
//                                         0, 0, 0, 16),
//                                     child: FFButtonWidget(
//                                       onPressed: () async {
//                                         // GoRouter.of(context).prepareAuthEvent();
//                                         // final user = await authManager
//                                         //     .signInWithGoogle(context);
//                                         // if (user == null) {
//                                         //   return;
//                                         // }

//                                         // context.goNamedAuth(
//                                         //     'profilePage', context.mounted);
//                                       },
//                                       text: 'Continue with Google',
//                                       icon: const FaIcon(
//                                         FontAwesomeIcons.google,
//                                         size: 20,
//                                       ),
//                                       options: FFButtonOptions(
//                                         width: double.infinity,
//                                         height: 44,
//                                         padding: const EdgeInsetsDirectional.fromSTEB(
//                                             0, 0, 0, 0),
//                                         iconPadding:
//                                             const EdgeInsetsDirectional.fromSTEB(
//                                                 0, 0, 0, 0),
//                                         color: FlutterFlowTheme.of(context)
//                                             .secondaryBackground,
//                                         textStyle: FlutterFlowTheme.of(context)
//                                             .titleSmall
//                                             .override(
//                                               fontFamily: 'Inter',
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .primaryText,
//                                             ),
//                                         elevation: 0,
//                                         borderSide: BorderSide(
//                                           color: FlutterFlowTheme.of(context)
//                                               .alternate,
//                                           width: 2,
//                                         ),
//                                         borderRadius: BorderRadius.circular(12),
//                                         hoverColor: FlutterFlowTheme.of(context)
//                                             .primaryBackground,
//                                       ),
//                                     ),
//                                   ),

//                                   // You will have to add an action on this rich text to go to your login page.
//                                   Padding(
//                                     padding: const EdgeInsetsDirectional.fromSTEB(
//                                         0, 12, 0, 12),
//                                     child: InkWell(
//                                       splashColor: Colors.transparent,
//                                       focusColor: Colors.transparent,
//                                       hoverColor: Colors.transparent,
//                                       highlightColor: Colors.transparent,
//                                       onTap: () async {
//                                         // context.pushNamed(
//                                           // 'Login',
//                                           // extra: <String, dynamic>{
//                                           //   kTransitionInfoKey: TransitionInfo(
//                                           //     hasTransition: true,
//                                           //     transitionType: PageTransitionType
//                                           //         .rightToLeft,
//                                           //   ),
//                                           // },
//                                         // );
//                                       },
//                                       child: RichText(
//                                         text: TextSpan(
//                                           children: [
//                                             const TextSpan(
//                                               text: 'Don\'t have an account?  ',
//                                               style: TextStyle(),
//                                             ),
//                                             TextSpan(
//                                               text: 'Sign Up here',
//                                               style: FlutterFlowTheme.of(
//                                                       context)
//                                                   .bodyMedium
//                                                   .override(
//                                                     fontFamily: 'Inter',
//                                                     color: FlutterFlowTheme.of(
//                                                             context)
//                                                         .primary,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                             )
//                                           ],
//                                           style: FlutterFlowTheme.of(context)
//                                               .bodyMedium,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ).animateOnPageLoad(
//                             animationsMap['containerOnPageLoadAnimation']!),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

