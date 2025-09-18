using AuthenticationServices.Common;
using System;
using System.Text;

namespace AuthenticationServices.Models.User
{
    public class UserProfileInputModel : InputModelBase
    {
        public UserProfileInputModel() : base(InputTypeGuidConstants.UserInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string MobileNo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", MobileNo = " + MobileNo);
            return stringBuilder.ToString();
        }

    }
}
