using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class ProductSpEntity
    {
        public Guid Id { get; set; }
        public string ProductName { get; set; }
        public Guid CompanyId { get; set; }
    }
}
