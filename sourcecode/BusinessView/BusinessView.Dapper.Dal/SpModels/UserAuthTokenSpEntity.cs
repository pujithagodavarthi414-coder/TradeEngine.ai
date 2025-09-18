using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class UserAuthTokenSpEntity
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public DateTime? DateCreated { get; set; }
        public string AuthToken { get; set; }
        public Guid CompanyId { get; set; }
    }
}
