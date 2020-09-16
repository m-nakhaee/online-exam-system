package onlineSchool.model.entity.mainEntities;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.KeyDeserializer;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;

public class QuestionKeyDeserializer extends KeyDeserializer {
private ObjectMapper mapper = new ObjectMapper();
    @Override
    public Question deserializeKey(
            String key,
            DeserializationContext ctxt) throws IOException,
            JsonProcessingException {
        return mapper.readValue(key, Question.class);
    }
}