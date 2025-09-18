using System;
using System.Text;
using AuthenticationServices.Common;

namespace AuthenticationServices.Models.User
{
    public class UserPasswordResetModel : InputModelBase
    {
        public UserPasswordResetModel() : base(InputTypeGuidConstants.ResetPasswordInputCommandTypeGuid)
        {
        }

        public Guid? UserId { get; set; }
        public Guid? ResetGuid { get; set; }
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }
        public string ConfirmPassword { get; set; }
        public int? Type { get; set; }
        public bool? IsArchived { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", ResetGuid = " + ResetGuid);
            stringBuilder.Append(", OldPassword = " + OldPassword);
            stringBuilder.Append(", NewPassword = " + NewPassword);
            stringBuilder.Append(", ConfirmPassword = " + ConfirmPassword);
            stringBuilder.Append(", Type = " + Type);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
