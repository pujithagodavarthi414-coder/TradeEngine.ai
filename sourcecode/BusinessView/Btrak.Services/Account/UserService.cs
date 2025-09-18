using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.Account
{
    public class UserService
    {
        private readonly UserRepository _userRepository;

        public UserService()
        {
            _userRepository = new UserRepository();
        }

        public UsersModel GetUser(Guid id)
        {
            var data = _userRepository.GetSingleUserDetails(id);

            if (data != null)
            {
                var model = new UsersModel
                {
                    Id = data.Id,
                    FirstName = data.FirstName,
                    SurName = data.SurName,
                    UserName = data.UserName,
                    IsActive = data.IsActive,
                    //RoleId = data.RoleId,
                    IsAdmin = data.IsAdmin != null && (bool)data.IsAdmin,
                    ProfileImage = data.ProfileImage,
                    CompanyGuid = data.CompanyId
                };

                return model;
            }
            return null;
        }

        public Guid GetUserId(string userName)
        {
            var user = _userRepository.GetUserDetailsByName(userName).FirstOrDefault();
            return user?.Id ?? Guid.Empty;
        }


        public UserModel ReadItem(Guid id)
        {
            var userDetails = _userRepository.GetSingleUserDetails(id);
            var userModel = new UserModel
            {
                Id = userDetails.Id,
                UserName = userDetails.UserName,
                Name = userDetails.FirstName
            };
            return userModel;
        }

        public void UpdatePassword(UserModel model)
        {
            if (model.Id == Guid.Empty) return;

            if (model.Id != null)
            {
                var maintainuser = _userRepository.GetSingleUserDetails(model.Id.Value);

                if (maintainuser != null)
                {

                    var userDbEntity = new UserDbEntity
                    {
                        Id = maintainuser.Id,
                        Password = model.Password,
                        UpdatedByUserId = maintainuser.Id,
                        UpdatedDateTime = DateTime.Now
                    };
                    _userRepository.UpdateUserPassword(userDbEntity);
                }
            }
            else
            {
                throw new Exception("Unexpected exception");
            }
        }

        public List<UsersModel> GetUsers(int type)
        {
            var usersList = _userRepository.SelectAll();
            //if (type == 1)
            //{
            //    usersList = entities.Users.Where(x=>x.IsActive == true).ToList();
            //}
            //else if (type == 2)
            //{
            //    usersList = entities.Users.Where(x => x.IsActive == true && x.IsAdmin == true).ToList();
            //}
            //else if (type == 3)
            //{
            //    usersList = entities.Users.Where(x => x.IsActive == true).ToList();
            //}
            return usersList.Select(x => new UsersModel
            {
                Id = x.Id,
                FirstName = x.FirstName,
                SurName = x.SurName,
                UserName = x.UserName,
                Password = x.Password,
                //RoleName = x.Role.RoleName,
                //BranchName = x.Branch.BranchName,
                IsActive = (bool)x.IsActive,
                IsAdmin = x.IsAdmin != null && (bool)x.IsAdmin
            }).OrderBy(x => x.FullName).ToList();
        }
    }
}