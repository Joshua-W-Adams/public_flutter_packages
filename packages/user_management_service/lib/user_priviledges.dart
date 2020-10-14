// part of user_management_service;

// /// Temporary class to house basic role based priviledges for a logged in user.
// class UserManagementService {
//   // final UserModel user;

//   // UserManagementService({@required this.user});

//   // ******************************** Abilities ********************************
//   bool canRead() {
//     const allowed = ['admin', 'editor', 'subscriber'];
//     return _checkAuthorization(allowed);
//   }

//   bool canEdit() {
//     const allowed = ['admin', 'editor'];
//     return _checkAuthorization(allowed);
//   }

//   bool canDelete() {
//     const allowed = ['admin'];
//     return _checkAuthorization(allowed);
//   }

//   bool _checkAuthorization(List<String> allowedRoles) {
//     if (this.user != null) {
//       return false;
//     }
//     for (var i = 0; i < allowedRoles.length; i++) {
//       // TODO - update user model to accept multiple roles

//       // abstract class Roles {
//       //   final bool free;
//       //   final bool premium;
//       //   final bool trainer;
//       //   final bool admin;
//       //   Roles({
//       //     @required this.free,
//       //     @required this.premium,
//       //     @required this.trainer,
//       //     @required this.admin,
//       //   });
//       // }

//       // if (user.user_role == allowedRoles[i]) {
//       //   return true;
//       // }
//     }
//     return false;
//   }
// }
