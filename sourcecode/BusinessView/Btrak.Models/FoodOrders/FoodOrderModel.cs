using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using BTrak.Common;

namespace Btrak.Models.FoodOrders
{
    public class FoodOrdersModel
    {
        public Guid Id { get; set; }
        [Required]
        public string FoodItems { get; set; }

        [EnsureOneElement(ErrorMessage = "At least a receipt is required")]
        public List<FoodOrderReceiptModel> OrderReceipts { get; set; }

        public Guid[] FoodOrderMembers { get; set; }

        [Range(1, 9999999999999999.99, ErrorMessage = UserDisplayMessages.PleaseEnterValidPrice)]
        public decimal Amount { get; set; }

        public string FoodOrderStatus { get; set; }
        public string Reason { get; set; }

        [Required]
        public DateTime? OrderedDate { get; set; }

        public string Comment { get; set; }
    }

    public class FoodOrderStatusModel
    {
        public Guid Id { get; set; }
        public string FoodOrderStatus { get; set; }
        public Guid FoodOrderStatusId { get; set; }
        public string Reason { get; set; }
    }

    public class FoodOrdersDisplayModel
    {
        public List<string> OrderReceipts { get; set; }
        public Guid? OrderId { get; set; }
        public string OrderDate { get; set; }
        public string Comment { get; set; }
        public int MemberCount { get; set; }
        public decimal? Amount { get; set; }
        public string ClaimByFirstName { get; set; }
        public string ClaimBySurName { get; set; }
        public string ClaimByUser => ClaimByFirstName + " " + ClaimBySurName;
        public string ClaimApprovedByFirstName { get; set; }
        public string ClaimApprovedBySurName { get; set; }
        public string ApprovedByUser => ClaimApprovedByFirstName + " " + ClaimApprovedBySurName;
        public string ClaimStatus { get; set; }
        public string FoodOrderItems { get; set; }
        public string EmployeeNames { get; set; }
        public DateTime OrderedDateTime { get; set; }
        public DateTime? StatusSetDateTime { get; set; }
        public string Reason { get; set; }
        public string OrderedDate { get; set; }
        public string ReceiptName { get; set; }
    }

    public class FoodOrdersGraphModel
    {
        public List<object> OrderDates { get; set; }
        public List<object> Amount { get; set; }
    }

    public class FoodOrderReceiptModel
    {
        public Guid? FoodOrderId { get; set; }
        public string ReceiptName { get; set; }
        public string ReceiptPath { get; set; }
    }

    public class EnsureOneElementAttribute : ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            var list = value as IList;
            if (list != null)
            {
                return list.Count > 0;
            }

            return false;
        }
    }
}
