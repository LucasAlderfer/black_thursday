require './test/test_helper.rb'
require './lib/sales_analyst.rb'

class SalesAnalystTest < Minitest::Test

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices  => "./data/invoices.csv"
      })
    merchants = se.load_file(se.content[:merchants])
    items = se.load_file(se.content[:items])
    invoices = se.load_file(se.content[:invoices])
    @mr = MerchantRepository.new(merchants)
    @ir = ItemRepository.new(items)
    @in = InvoiceRepository.new(invoices)
    @sa = SalesAnalyst.new(se)
  end

  def test_it_exists
    assert_instance_of SalesAnalyst, @sa
  end

  def test_it_can_find_the_items_per_merchant
    first_id = @ir.all[0].merchant_id
    second_id = @ir.all[1].merchant_id
    assert_equal 1, @sa.items_per_merchant[0]
    assert_equal 6, @sa.items_per_merchant[1]
  end

  def test_analyst_can_check_average_items_per_merchant
    assert_equal 2.88, @sa.average_items_per_merchant
  end

  def test_can_find_the_standard_deviation_for_average_items_per_merchant
    assert_equal 3.26, @sa.average_items_per_merchant_standard_deviation
  end

  def test_it_can_find_merchants_offering_high_item_count
    assert_equal 52, @sa.merchants_with_high_item_count.length
    assert_instance_of Merchant, @sa.merchants_with_high_item_count.first
  end

  def test_it_can_find_average_item_price_per_merchant
    merchant_id = 12334105
    assert_equal 16.66, @sa.average_item_price_for_merchant(12334105)
  end

  def test_it_can_find_average_average_item_price_per_merchant
    assert_equal 350.29, @sa.average_average_price_per_merchant
  end

  def test_it_can_find_the_price_standard_deviation
    assert_equal 2900.99, @sa.item_price_standard_deviation
  end

  def test_it_can_find_all_golden_items
    assert_equal 5, @sa.golden_items.length
    assert_equal Item, @sa.golden_items.first.class
  end

  def test_it_can_find_the_invoices_per_merchant
    first_id = @in.all[0].merchant_id
    second_id = @in.all[1].merchant_id
    assert_equal 16, @sa.invoices_per_merchant[0]
    assert_equal 15, @sa.invoices_per_merchant[1]
  end

  def test_it_can_find_the_average_invoices_per_merchant
    assert_equal 10.49, @sa.average_invoices_per_merchant
  end

  def test_it_can_find_the_average_invoices_per_merchant_standard_devaition
    assert_equal 3.29, @sa.average_invoices_per_merchant_standard_deviation
  end

  def test_it_can_find_top_performing_merchants
    assert_equal 12, @sa.top_merchants_by_invoice_count.count
    assert_instance_of Merchant, @sa.top_merchants_by_invoice_count[0]
  end

  def test_it_can_find_bottom_performing_merchants
    assert_equal 4, @sa.bottom_merchants_by_invoice_count.count
    assert_instance_of Merchant, @sa.bottom_merchants_by_invoice_count[0]
  end

end
