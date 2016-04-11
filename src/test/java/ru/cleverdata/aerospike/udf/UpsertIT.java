package ru.cleverdata.aerospike.udf;

import com.aerospike.client.AerospikeClient;
import com.aerospike.client.AerospikeException;
import com.aerospike.client.Bin;
import com.aerospike.client.Key;
import com.aerospike.client.Language;
import com.aerospike.client.Record;
import com.aerospike.client.ScanCallback;
import com.aerospike.client.Value;
import com.aerospike.client.policy.ClientPolicy;
import com.aerospike.client.policy.ScanPolicy;
import com.aerospike.client.task.RegisterTask;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.notNullValue;
import static org.hamcrest.Matchers.nullValue;

@Test(singleThreaded = true)
public class UpsertIT {

    private AerospikeClient aerospike;

    @BeforeMethod
    public void setUp() throws Exception {
        ClientPolicy policy = new ClientPolicy();
        policy.failIfNotConnected = true;

        aerospike = new AerospikeClient(policy, "localhost", 3000);
        RegisterTask task =
            aerospike.register(null, getClass().getClassLoader(), "lua/upsert.lua", "upsert.lua", Language.LUA);
        task.waitTillComplete();
    }

    @AfterMethod
    public void tearDown() throws Exception {
        ScanPolicy policy = new ScanPolicy();
        policy.includeBinData = false;

        aerospike.scanAll(policy, "test", getClass().getSimpleName(), new ScanCallback() {
            public void scanCallback(Key key, Record record) throws AerospikeException {
                aerospike.delete(null, key);
            }
        });

        aerospike.removeUdf(null, "upsert.lua");
        aerospike.close();
    }

    @Test
    public void shouldUpdateExistingRecord() throws Exception {
        Key key = new Key("test", getClass().getSimpleName(), "1");
        aerospike.put(null, key, new Bin("value", Value.get("Bye World!")));

        Record record = aerospike.get(null, key);
        assertThat(record, notNullValue());

        Object result = aerospike.execute(null, key, "upsert", "upsert", Value.get("value"), Value.get("Hello World!"));
        assertThat(result, nullValue());

        record = aerospike.get(null, key);
        assertThat((String) record.bins.get("value"), equalTo("Hello World!"));
    }

    @Test
    public void shouldCreateNewRecord() throws Exception {
        Key key = new Key("test", getClass().getSimpleName(), "2");

        Record record = aerospike.get(null, key);
        assertThat(record, nullValue());

        Object result = aerospike.execute(null, key, "upsert", "upsert", Value.get("value"), Value.get("Hello World!"));
        assertThat(result, nullValue());

        record = aerospike.get(null, key);
        assertThat((String) record.bins.get("value"), equalTo("Hello World!"));
    }

}
