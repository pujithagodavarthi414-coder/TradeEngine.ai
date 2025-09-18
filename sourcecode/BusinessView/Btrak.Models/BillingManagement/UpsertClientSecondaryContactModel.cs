using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.BillingManagement
{
    public class UpsertClientSecondaryContactModel : InputModelBase
    {
        public UpsertClientSecondaryContactModel() : base(InputTypeGuidConstants.UpsertClientSecondaryContactCommandTypeGuid)
        {
        }

        public Guid? ClientSecondaryContactId { get; set; }
        public Guid? ClientId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string MobileNo { get; set; }
        public string ProfileImage { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public string Password { get; set; }
        public List<Guid> RoleId { get; set; }
        public string RoleIds { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ClientSecondaryContactId" + ClientSecondaryContactId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("FirstName" + FirstName);
            stringBuilder.Append("LastName" + LastName);
            stringBuilder.Append("Email" + Email);
            stringBuilder.Append("MobileNo" + MobileNo);
            stringBuilder.Append("ProfileImage" + ProfileImage);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            stringBuilder.Append("Password" + Password);
            return base.ToString();
        }
    }
}