using System;

namespace Btrak.Models
{
    public class UserMiniModel
    {
        public Guid? Id
        {
            get;
            set;
        }

        public Guid? UserAuthenticationId
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