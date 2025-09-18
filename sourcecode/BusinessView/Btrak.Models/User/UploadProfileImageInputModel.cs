using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.User
{
    public class UploadProfileImageInputModel : InputModelBase
    {
        public UploadProfileImageInputModel() : base(InputTypeGuidConstants.UploadProfileImageInputCommandTypeGuid)
        {
        }

        public string ProfileImage { get; set; }
        public string LogoType { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ProfileImage = "+ ProfileImage);
            stringBuilder.Append(", UserId  = " + UserId);
            return stringBuilder.ToString();
        }
    }
}