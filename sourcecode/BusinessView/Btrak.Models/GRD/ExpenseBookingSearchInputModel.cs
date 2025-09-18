using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GRD
{
    public class ExpenseBookingSearchInputModel : SearchCriteriaInputModelBase
    {
        public ExpenseBookingSearchInputModel() : base(InputTypeGuidConstants.ExpenseBookingSearchInputModelCommandTypeGuid)
        {
        }
        public Guid? ExpenseBookingId { get; set; }
    }
}
