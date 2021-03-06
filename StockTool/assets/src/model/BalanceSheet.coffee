TableBase 	= require "./TableBase"
utils 		= require '../tools/utils'
TitleName 	= require "../title"

class BalanceSheet extends TableBase
	getFilePath:->
		"allA/zcfzb_#{@_stockCode}"

	getFirstColTitle: ->
		TitleName.getBalanceTitle()

	getCashValue: -> @getValue(@_data["货币资金(万元)"])

	getTotalAssets: -> @getValue(@_data["资产总计(万元)"])

	getNetAssets: -> @getValue(@_data["归属于母公司股东权益合计(万元)"])

	_getNoNeedCalcItems: -> ["资料", "报告日期"]

	getReceivableValue: -> @getValue(@_data["应收账款(万元)"])

	getStaffPayment: -> 
		valueTable = @getValue(@_data["应付职工薪酬(万元)"])
		return valueTable[0] - valueTable[1]

	getInterestDebt: ->
		value1 = @getValue(@_data["短期借款(万元)"])[0]
		value2 = @getValue(@_data["长期借款(万元)"])[0]
		value3 = @getValue(@_data["应付债券(万元)"])[0]
		totalAssets = @getTotalAssets()[0]
		return ((value1 + value2 + value3) / totalAssets * 100).toFixed(2)

	getTop10: ->
		totalAssets = @getTotalAssets()
		assetsPercentTable = {}
		for key , value of @_data
			continue if value[0] is 0
			continue if key in @_getNoNeedCalcItems()
			percent = @getValue(value)[0] / totalAssets[0] * 100
			assetsPercentTable[key] = percent.toFixed(2)
		sortedObjKeys = Object.keys(assetsPercentTable).sort(
			(a, b)->
				return assetsPercentTable[b] - assetsPercentTable[a]
		)
		useAbleTable = []
		disAbleTable = ["固定资产净值(万元)", "固定资产原值(万元)", "未分配利润(万元)", "盈余公积(万元)", "资本公积(万元)", "少数股东权益(万元)", "实收资本(或股本)(万元)"]
		for key in sortedObjKeys
			continue if key.indexOf("计") isnt -1
			continue if key in disAbleTable
			useAbleTable.push key
		top10Key = useAbleTable.slice(0, 10)
		top10Info = []
		for key in top10Key
			top10Info.push key.slice(0, key.indexOf("(")) + ":" + assetsPercentTable[key] + '%'
		top10Info


	getCurrentRatio: ->
		currentAssetsTable = @getValue(@_data["流动资产合计(万元)"])
		currentDebtsTable = @getValue(@_data["流动负债合计(万元)"])
		currentRatio = []
		for currentAssets, index in currentAssetsTable
			currentRatio.push (currentAssets / currentDebtsTable[index]).toFixed(2)
		currentRatio

	getQuickRatio: ->
		currentAssetsTable = @getValue(@_data["流动资产合计(万元)"])
		currentDebtsTable = @getValue(@_data["流动负债合计(万元)"])
		inventoryTable = @getValue(@_data["存货(万元)"])
		quickRatio = []
		for currentAssets, index in currentAssetsTable
			quickRatio.push ((currentAssets - inventoryTable[index]) / currentDebtsTable[index]).toFixed(2)
		quickRatio

	getAdvanceReceiptsPercent: ->
		advanceReceiptsTable = @getValue(@_data["预收账款(万元)"])
		totalAssetsTable = @getTotalAssets()
		percent = []
		# for advanceReceipt, index in advanceReceiptsTable
		# 	percent.push (advanceReceipt / totalAssetsTable[index]) * 100
		percent = (advanceReceiptsTable[0] / totalAssetsTable[0]) * 100
		return percent.toFixed(2)

	getSingleYearAverageInventory: ->
		inventoryTable = @getValue(@_data["存货(万元)"])
		averageInventory = (inventoryTable[0] + inventoryTable[1]) / 2
		averageInventory

	getSingleYearAveragePayable: ->
		payableTable = @getValue(@_data["应付账款(万元)"])
		averagePayable = (payableTable[0] + payableTable[1]) / 2
		averagePayable

	getSingleYearAverageTotalAssets: ->
		totalAssetsTable = @getTotalAssets()
		averageTotalAssets = (totalAssetsTable[0] + totalAssetsTable[1]) / 2
		averageTotalAssets

	getInvestAssets: ->
		financial = @getValue(@_data["可供出售金融资产(万元)"])[0]
		endInvest = @getValue(@_data["持有至到期投资(万元)"])[0]
		longInvest = @getValue(@_data["长期股权投资(万元)"])[0]
		return ((financial + endInvest + longInvest) / @getTotalAssets()[0] * 100).toFixed(2)

	getGoodWill: ->
		goodWill = @getValue(@_data["商誉(万元)"])[0]
		goodWill

	getFinancialLeverage: ->
		averageTotalAssets = @getSingleYearAverageTotalAssets()
		netAssets = @getNetAssets()[0]
		ratio = (averageTotalAssets / netAssets).toFixed(2)
		ratio

	getNetAssetsStruct: ->
		number1 = @getValue(@_data["实收资本(或股本)(万元)"])[0]
		number2 = @getValue(@_data["资本公积(万元)"])[0]
		number3 = @getValue(@_data["盈余公积(万元)"])[0]
		number4 = @getValue(@_data["未分配利润(万元)"])[0]

		result = (number3 + number4) / (number1 + number2)
		return result.toFixed(2)

module.exports = BalanceSheet