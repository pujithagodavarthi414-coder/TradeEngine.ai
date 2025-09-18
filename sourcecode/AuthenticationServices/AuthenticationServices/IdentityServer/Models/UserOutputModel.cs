using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IdentityServer.Models
{
    public class UserOutputModel
    {
        public Guid UserId { get; set; }
        public Guid CompanyId { get; set; }
        public Guid UserCompanyId { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Password { get; set; }
        public string FullName { get; set; }
        public bool? IsActive { get; set; }
        public string MobileNo { get; set; }
        public string ProfileImage { get; set; }
    }
}
