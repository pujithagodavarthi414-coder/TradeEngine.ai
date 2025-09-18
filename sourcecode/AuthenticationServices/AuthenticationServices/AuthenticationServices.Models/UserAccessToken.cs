using System;

namespace AuthenticationServices.Models
{
    public class UserAccessToken
    {
        public Guid UserId { get; set; }
        public Guid CompanyId { get; set; }
        public DateTime? DateCreated { get; set; }
        public string AccessToken { get; set; }
    }
}
