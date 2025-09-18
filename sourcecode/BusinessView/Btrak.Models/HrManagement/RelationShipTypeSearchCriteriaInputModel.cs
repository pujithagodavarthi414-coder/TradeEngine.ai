using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class RelationShipTypeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public RelationShipTypeSearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchRelationship)
        {
        }

        public Guid? RelationshipId { get; set; }
        public string RelationshipName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RelationshipId = " + RelationshipId);
            stringBuilder.Append(", RelationshipName = " + RelationshipName);
            stringBuilder.Append(", Timestamp = " + TimeStamp);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}