using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ClientSecondaryContactOutputModel
    {
        public Guid? ClientSecondaryContactId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? ClientReferenceUserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName { get; set; }
        public string AvatarName { get; set; }
        public string Email { get; set; }
        public string MobileNo { get; set; }
        public string ProfileImage { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public List<Guid> RoleId { get; set; }
        public string RoleIds { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ClientSecondaryContactId" + ClientSecondaryContactId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("ClientReferenceUserId" + ClientReferenceUserId);
            stringBuilder.Append("FirstName" + FirstName);
            stringBuilder.Append("LastName" + LastName);
            stringBuilder.Append("FullName" + FullName);
            stringBuilder.Append("AvatarName" + AvatarName);
            stringBuilder.Append("Email" + Email);
            stringBuilder.Append("MobileNo" + MobileNo);
            stringBuilder.Append("ProfileImage" + ProfileImage);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
