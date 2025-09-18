using BTrak.Common;
using System;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class ResignationStatusSearchInputModel : SearchCriteriaInputModelBase
    {
        public ResignationStatusSearchInputModel() : base(InputTypeGuidConstants.PayRollResignationStatusGuid)
        {
        }

        public Guid? ResignationStatusId { get; set; }
        [StringLength(50)]
        public string StatusName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ResignationStatusId= " + ResignationStatusId);
            stringBuilder.Append(", StatusName= " + StatusName);
            stringBuilder.Append(", IsArchived= " + IsArchived);
            stringBuilder.Append(", TimeStamp= " + TimeStamp);
            return stringBuilder.ToString();
        }

    }
}
