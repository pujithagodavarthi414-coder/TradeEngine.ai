using System;
using System.Text;

namespace Btrak.Models.Supplier
{
    public class SuppliersDropDownOutputModel
    {
        public Guid? SupplierId { get; set; } 
        public string SupplierName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", SupplierId = " + SupplierId);
            stringBuilder.Append(", SupplierName = " + SupplierName);
            return stringBuilder.ToString();
        }
    }
}