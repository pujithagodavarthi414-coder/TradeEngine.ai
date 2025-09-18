using System;
using System.Text;

namespace Btrak.Models.Role
{
    public class RoleDropDownOutputModel
    {
        public Guid? RoleId { get; set; }
        public Guid? Value { get; set; }
        public string RoleName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Value = " + Value);
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", RoleName = " + RoleName);
            return stringBuilder.ToString();
        }
    }
}