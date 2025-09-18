using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class FoodOrderReceiptSpEntity
    {
        public Guid OrderId { get; set; }
        public Guid CompanyId { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
    }
}
