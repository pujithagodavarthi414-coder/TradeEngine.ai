using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeMembershipRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeMembership table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeMembershipDbEntity aEmployeeMembership)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeMembership.Id);
					 vParams.Add("@EmployeeId",aEmployeeMembership.EmployeeId);
					 vParams.Add("@MembershipId",aEmployeeMembership.MembershipId);
					 vParams.Add("@SubscriptionId",aEmployeeMembership.SubscriptionId);
					 vParams.Add("@SubscriptionAmount",aEmployeeMembership.SubscriptionAmount);
					 vParams.Add("@CurrencyId",aEmployeeMembership.CurrencyId);
					 vParams.Add("@CommenceDate",aEmployeeMembership.CommenceDate);
					 vParams.Add("@RenewalDate",aEmployeeMembership.RenewalDate);
					 vParams.Add("@CreatedDateTime",aEmployeeMembership.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeMembership.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeMembership.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeMembership.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeMembershipInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeMembership table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeMembershipDbEntity aEmployeeMembership)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeMembership.Id);
					 vParams.Add("@EmployeeId",aEmployeeMembership.EmployeeId);
					 vParams.Add("@MembershipId",aEmployeeMembership.MembershipId);
					 vParams.Add("@SubscriptionId",aEmployeeMembership.SubscriptionId);
					 vParams.Add("@SubscriptionAmount",aEmployeeMembership.SubscriptionAmount);
					 vParams.Add("@CurrencyId",aEmployeeMembership.CurrencyId);
					 vParams.Add("@CommenceDate",aEmployeeMembership.CommenceDate);
					 vParams.Add("@RenewalDate",aEmployeeMembership.RenewalDate);
					 vParams.Add("@CreatedDateTime",aEmployeeMembership.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeMembership.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeMembership.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeMembership.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeMembershipUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeMembership table.
		/// </summary>
		public EmployeeMembershipDbEntity GetEmployeeMembership(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeMembershipDbEntity>("USP_EmployeeMembershipSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeMembership table.
		/// </summary>
		 public IEnumerable<EmployeeMembershipDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeMembershipDbEntity>("USP_EmployeeMembershipSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeMembership table by a foreign key.
		/// </summary>
		public List<EmployeeMembershipDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeMembershipDbEntity>("USP_EmployeeMembershipSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
