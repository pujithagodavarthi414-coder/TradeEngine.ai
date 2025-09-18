using System;

namespace AuthenticationServices.Models
{
    public class UserMiniModel
    {
        public Guid? Id
        {
            get;
            set;
        }

        public string Name
        {
            get;
            set;
        }

        public string ProfileImage
        {
            get;
            set;
        }
    }
}
