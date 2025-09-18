using Btrak.Models.Notification;
using BTrak.Common;
using BTrak.Common.Constants;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
        public class NotificationModelForPurchaseExecution : NotificationBase
        {
            public Guid? PurchaseGuid { get; }
            public string PurchaseName { get; }
            public Guid? PurchaseDutyPersonId { get; }
            public Guid? ContractId { get; }

            public NotificationModelForPurchaseExecution(string summary,
                Guid? purchaseGuid, Guid? contractId,
                string purchaseName, Guid? purchaseDutyPersonId) : base(NotificationTypeConstants.PurchaseExecutionAssignToEmployeeNotification, summary
            )
            {
            PurchaseGuid = purchaseGuid;
            PurchaseName = purchaseName;
            PurchaseDutyPersonId = purchaseDutyPersonId;
            ContractId = contractId;
                Channels.Add(string.Format(NotificationChannelNamesConstants.PurchaseExecutionAssignToEmployeeNotification, purchaseDutyPersonId));
            }
        }
}
