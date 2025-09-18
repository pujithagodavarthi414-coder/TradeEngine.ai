
using BusinessView.Api.Models;
using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class UsersApiController : ApiController
    {
        private readonly IUserService _userService;
        private readonly IAuditService _auditService;
        private readonly IBlobService _blobService;

        public UsersApiController()
        {
            _userService = new UserService();
            _auditService = new AuditService();
            _blobService = new BlobService();
        }

        [HttpGet]
        public List<UsersModel> GetAllUsers()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Users", "Users Api"));

            List<UsersModel> usersList;

            try
            {
                usersList = _userService.GetAllUsers(1);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get All Users", "Users Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Users", "Users Api"));

            return usersList;
        }

        public UsersModel Get(int id)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get User", "Users Api"));

            UsersModel user;

            try
            {
                user = _userService.GetUser(id);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get User", "Users Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get User", "Users Api"));

            return user;
        }

        public List<UserModel> GetEmployeeList()
        {
            var result = new List<UserModel> { new UserModel { Name = "All", Id = -1 }, new UserModel { Name = "Anonymous User", Id = null } };
            var list = _userService.GetEmployeeNames();
            result.AddRange(list);
            return result;
        }

        [HttpPost]
        public string AddUser(UsersModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add User", "Users Api"));

            if (ModelState.IsValid)
            {
                if (_userService.CheckEmailExists(model))
                {
                    ModelState.AddModelError("UserEmail", "Email already exists.");

                    var result = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add User", "Users Api"));

                    return JsonConvert.SerializeObject(result);
                }

                var userId = _userService.AddOrUpdate(model);
                var userName = _userService.GetUserName(userId);

                var loggedUserId = User.Identity.GetUserId<int>();
                var loggedUserName = _userService.GetUserName(loggedUserId);

                var auditModel = new AuditModel
                {
                    UserId = loggedUserId,
                    FiledName = "New user added",
                    Description = "<strong>" + loggedUserName + "</strong>" + " added new user " + userName,
                    UpdatedDate = DateTime.Now
                };

                _auditService.AddOrUpdate(auditModel);

                var result1 = new BusinessViewJsonResult
                {
                    Success = true
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add User", "Users Api"));

                return JsonConvert.SerializeObject(result1);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add User", "Users Api"));

            return JsonConvert.SerializeObject(result2);
        }

        [HttpPut]
        public string UpdateUser(UsersModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update User", "Users Api"));

            var loggedUserId = User.Identity.GetUserId<int>();
            var loggedUserName = _userService.GetUserName(loggedUserId);

            if (model.Id > 0)
            {
                ModelState.Remove("Password");
            }

            if (ModelState.IsValid)
            {
                if (_userService.CheckEmailExists(model))
                {
                    ModelState.AddModelError("UserEmail", "Email address already exist.");

                    var result = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User", "Users Api"));

                    return JsonConvert.SerializeObject(result);
                }

                if (model.Id > 0)
                {
                    model.LoggedUserId = loggedUserId;
                    model.LoggedUserName = loggedUserName;
                    _userService.AddOrUpdate(model);
                }

                var result1 = new BusinessViewJsonResult
                {
                    Success = true
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User", "Users Api"));

                return JsonConvert.SerializeObject(result1);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User", "Users Api"));

            return JsonConvert.SerializeObject(result2);
        }

        [Authorize]
        [HttpPost]
        public string UpdateForceResetPassword(ChangePasswordModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update Force Reset Password", "Users Api"));

            try
            {
                ModelState.Remove("model.Password");

                if (ModelState.IsValid)
                {
                    var userId = User.Identity.GetUserId<int>();

                    using (var entities = new BViewEntities())
                    {
                        var user = entities.Users.FirstOrDefault(x => x.Id == userId);

                        if (user != null)
                        {
                            var encryptedNewPassword = AppUtilities.GetSaltedPassword(model.NewPassword);

                            var requestedUser = _userService.ReadItem(userId);

                            if (requestedUser != null)
                            {
                                requestedUser.Password = encryptedNewPassword;
                            }

                            _userService.UpdateForceResetPassword(requestedUser);

                            var matchedPassword = new BusinessViewJsonResult
                            {
                                Success = true
                            };

                            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Force Reset Password", "Users Api"));

                            return JsonConvert.SerializeObject(matchedPassword);

                        }
                    }
                }

                var result = new BusinessViewJsonResult
                {
                    Success = false,
                    ModelState = ModelState
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Force Reset Password", "Users Api"));

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update Force Reset Password", "Users Api", ex.Message));

                throw;
            }
        }

        public string UploadProfileImage()
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var userId = ConversionHelper.ConvertToInt32(HttpContext.Current.Request.Form["Id"]);
                    var filepath = GetFilePath();

                    var userDetails = entities.Users.FirstOrDefault(x => x.Id == userId);
                    userDetails.ProfileImage = filepath;
                    entities.SaveChanges();

                    var result = new BusinessViewJsonResult
                    {
                        Success = true,
                        Data = filepath
                    };

                    return JsonConvert.SerializeObject(result);
                }
            }
            catch (Exception exception)
            {
                var result = new BusinessViewJsonResult
                {
                    Success = false,
                };

                return JsonConvert.SerializeObject(result);
            }
        }

        private string GetFilePath()
        {
            try
            {
                LoggingManager.Debug("Entered into SaveFile method of employee api controller");

                var filePath = string.Empty;

                var files = HttpContext.Current.Request.Files["ProfileImage"];

                if (files != null)
                {
                    var name = Path.GetFileName(files.FileName);

                    var fileExtension = Path.GetExtension(name);

                    var isValidFile = IsFileTypeValid(fileExtension);

                    if (isValidFile)
                    {
                        filePath = _blobService.UploadFile(files);
                    }
                }

                return filePath;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                throw;
            }
        }

        private bool IsFileTypeValid(string fileExtension)
        {
            try
            {
                string[] validExtensions = { ".jpg", ".gif", ".png", ".JPG", ".GIF", ".PNG" };

                if (validExtensions.Contains(fileExtension))
                {
                    return true;
                }

                return false;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                throw;
            }
        }

        public string DeleteProfileImage(int id)
        {
            try
            {
                _userService.DeleteUserImage(id);

                var result = new BusinessViewJsonResult
                {
                    Success = true
                };

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
                throw;
            }
        }
    }
}
