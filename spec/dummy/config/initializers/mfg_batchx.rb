MfgBatchx.order_class = 'MfgOrderx::Order'
MfgBatchx.rfq_class = 'JobshopRfqx::Rfq'
MfgBatchx.show_rfq_path = 'jobshop_rfqx.rfq_path(r.rfq_id)'
MfgBatchx.warehouse_checkin_path = "produced_item_warehousex.new_item_path(:batch_id => @batch.id, :name => @rfq.product_name + ' ' + @rfq.drawing_num, :qty => @batch.qty_produced)"
MfgBatchx.warehouse_item_class = 'ProducedItemWarehousex::Item'
MfgBatchx.customer_class = 'Kustomerx::Customer'
