using AuthenticationServices.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.User
{
    public class UserInputModel : InputModelBase
    {
        public UserInputModel() : base(InputTypeGuidConstants.UserInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string RoleId { get; set; }
        public bool IsPasswordForceReset { get; set; }
        public bool IsActive { get; set; }
        public bool IsExternal { get; set; }
        public Guid? TimeZoneId { get; set; }
        public Guid? DesktopId { get; set; }
        public string MobileNo { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public string ProfileImage { get; set; }
        public DateTime? LastConnection { get; set; }
        public bool IsArchived { get; set; }
        public string Password2 { get; set; }
        public string Email2 { get; set; }
        public string PhoneNumber2 { get; set; }
        public string LastName { get; set; }
        public string Role { get; set; }
        public Guid? ReferenceId { get; set; }
        public string Language { get; set; }
        public List<Guid> ModuleIds { get; set; }
        public string ModuleIdsXml { get; set; }
        public string IdentityServerCallback { get; set; }
        public bool UpdateProfileDetails { get; set; }
        public bool? IsFromClient { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", Password = " + Password);
            stringBuilder.Append(", RoleIds = " + RoleId);
            stringBuilder.Append(", IsPasswordForceReset = " + IsPasswordForceReset);
            stringBuilder.Append(", IsActive = " + IsActive);
            stringBuilder.Append(", TimeZoneId = " + TimeZoneId);
            stringBuilder.Append(", MobileNo = " + MobileNo);
            stringBuilder.Append(", IsAdmin = " + IsAdmin);
            stringBuilder.Append(", IsActiveOnMobile = " + IsActiveOnMobile);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", LastConnection = " + LastConnection);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", Language = " + Language);
            stringBuilder.Append(", ModuleIds = " + ModuleIds);
            stringBuilder.Append(", ModuleIdsXml = " + ModuleIdsXml);
            stringBuilder.Append(", IdentityServerCallback = " + IdentityServerCallback);
            stringBuilder.Append(", UpdateProfileDetails = " + UpdateProfileDetails);
            return stringBuilder.ToString();
        }
    }
}
