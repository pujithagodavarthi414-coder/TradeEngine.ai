using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeSalaryRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeSalary table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeSalaryDbEntity aEmployeeSalary)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeSalary.Id);
					 vParams.Add("@EmployeeId",aEmployeeSalary.EmployeeId);
					 vParams.Add("@SalaryPayGradeId",aEmployeeSalary.SalaryPayGradeId);
					 vParams.Add("@SalaryComponent",aEmployeeSalary.SalaryComponent);
					 vParams.Add("@SalaryPayFrequencyId",aEmployeeSalary.SalaryPayFrequencyId);
					 vParams.Add("@CurrencyId",aEmployeeSalary.CurrencyId);
					 vParams.Add("@Amount",aEmployeeSalary.Amount);
					 vParams.Add("@Comments",aEmployeeSalary.Comments);
					 vParams.Add("@IsAddedDepositDetails",aEmployeeSalary.IsAddedDepositDetails);
					 vParams.Add("@AccountNumber",aEmployeeSalary.AccountNumber);
					 vParams.Add("@AccountTypeId",aEmployeeSalary.AccountTypeId);
					 vParams.Add("@RoutingNumber",aEmployeeSalary.RoutingNumber);
					 vParams.Add("@DepositedAmount",aEmployeeSalary.DepositedAmount);
					 vParams.Add("@ActiveFrom",aEmployeeSalary.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeSalary.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeSalary.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeSalary.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeSalary.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeSalary.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeSalaryInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeSalary table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeSalaryDbEntity aEmployeeSalary)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeSalary.Id);
					 vParams.Add("@EmployeeId",aEmployeeSalary.EmployeeId);
					 vParams.Add("@SalaryPayGradeId",aEmployeeSalary.SalaryPayGradeId);
					 vParams.Add("@SalaryComponent",aEmployeeSalary.SalaryComponent);
					 vParams.Add("@SalaryPayFrequencyId",aEmployeeSalary.SalaryPayFrequencyId);
					 vParams.Add("@CurrencyId",aEmployeeSalary.CurrencyId);
					 vParams.Add("@Amount",aEmployeeSalary.Amount);
					 vParams.Add("@Comments",aEmployeeSalary.Comments);
					 vParams.Add("@IsAddedDepositDetails",aEmployeeSalary.IsAddedDepositDetails);
					 vParams.Add("@AccountNumber",aEmployeeSalary.AccountNumber);
					 vParams.Add("@AccountTypeId",aEmployeeSalary.AccountTypeId);
					 vParams.Add("@RoutingNumber",aEmployeeSalary.RoutingNumber);
					 vParams.Add("@DepositedAmount",aEmployeeSalary.DepositedAmount);
					 vParams.Add("@ActiveFrom",aEmployeeSalary.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeSalary.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeSalary.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeSalary.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeSalary.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeSalary.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeSalaryUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeSalary table.
		/// </summary>
		public EmployeeSalaryDbEntity GetEmployeeSalary(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeSalaryDbEntity>("USP_EmployeeSalarySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeSalary table.
		/// </summary>
		 public IEnumerable<EmployeeSalaryDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeSalaryDbEntity>("USP_EmployeeSalarySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeSalary table by a foreign key.
		/// </summary>
		public List<EmployeeSalaryDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeSalaryDbEntity>("USP_EmployeeSalarySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeSalary table by a foreign key.
		/// </summary>
		public List<EmployeeSalaryDbEntity> SelectAllBySalaryPayFrequencyId(Guid salaryPayFrequencyId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@SalaryPayFrequencyId",salaryPayFrequencyId);
				 return vConn.Query<EmployeeSalaryDbEntity>("USP_EmployeeSalarySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeSalary table by a foreign key.
		/// </summary>
		public List<EmployeeSalaryDbEntity> SelectAllBySalaryPayGradeId(Guid salaryPayGradeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@SalaryPayGradeId",salaryPayGradeId);
				 return vConn.Query<EmployeeSalaryDbEntity>("USP_EmployeeSalarySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeSalary table by a foreign key.
		/// </summary>
		public List<EmployeeSalaryDbEntity> SelectAllByCurrencyId(Guid currencyId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CurrencyId",currencyId);
				 return vConn.Query<EmployeeSalaryDbEntity>("USP_EmployeeSalarySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
