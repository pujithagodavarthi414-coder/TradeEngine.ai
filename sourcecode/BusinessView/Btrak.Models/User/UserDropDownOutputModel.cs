using System;
using System.Text;

namespace Btrak.Models.User
{
    public class UserDropDownOutputModel
    {
        public Guid? Id { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }
        public string UserName { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", FullName = " + FullName);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            return stringBuilder.ToString();
        }
    }
}