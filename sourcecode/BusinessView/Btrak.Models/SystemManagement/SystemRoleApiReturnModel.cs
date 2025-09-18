using System;
using System.Text;

namespace Btrak.Models.SystemManagement
{
    public class SystemRoleApiReturnModel
    {
        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RoleId = " + RoleId);
            stringBuilder.Append(", RoleName = " + RoleName);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
