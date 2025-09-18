using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.User
{
    public class GoogleNewUserModel
    {
        public string FirstName { get; set; }

        public string SurName { get; set; }

        public string Email { get; set; }

        public string Password { get; set; }

        public string ProfileImage { get; set; }

        public string UserDomain { get; set; }

        public string SiteAddress { get; set; }

        public bool CanByPassUserCompanyValidation { get; set; }
    }
}
