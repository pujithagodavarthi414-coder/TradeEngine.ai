using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.User
{
    public class ResetPasswordInputModel : InputModelBase
    {
        public ResetPasswordInputModel() : base(InputTypeGuidConstants.ResetPasswordInputCommandTypeGuid)
        {
        }
        public Guid ResetPasswordId
        {
            get;
            set;
        }

        public DateTime? CreatedOn
        {
            get;
            set;
        }

        public DateTime? ExpiredOn
        {
            get;
            set;
        }

        public bool? IsExpired
        {
            get;
            set;
        }

       
        public string Password
        {
            get;
            set;
        }

        
        public string NewPassword
        {
            get;
            set;
        }
      
        public string ConfirmPassword
        {
            get;
            set;
        }

        public Guid ResetGuid
        {
            get;
            set;
        }

        public Guid UserId
        {
            get;
            set;
        }

        public string FullName { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public Guid? LoggedUserId { get; set; }
        public int? Type { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? ExpiredDateTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ResetPasswordId = " + ResetPasswordId);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", ExpiredOn = " + ExpiredOn);
            stringBuilder.Append(", Password = " + Password);
            stringBuilder.Append(", NewPassword = " + NewPassword);
            stringBuilder.Append(", ConfirmPassword = " + ConfirmPassword);
            stringBuilder.Append(", ResetGuid = " + ResetGuid);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", FullName = " + FullName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", LoggedUserId = " + LoggedUserId);
            stringBuilder.Append(", IsExpired = " + IsExpired);
            stringBuilder.Append(", Type = " + Type);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", ExpiredDateTime = " + ExpiredDateTime);
            return stringBuilder.ToString();
        }
    }
}
