using System;

namespace AuthenticationServices.Models
{
    public class ValidUserOutputmodel
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string FullName { get; set; }
        public bool? IsAdmin { get; set; }
        public string ProfileImage { get; set; }
        public Guid CompanyId { get; set; }
        public Guid? UserAuthenticationId { get; set; }
    }
}
