package com.lchjy.service.impl;

import com.lchjy.entity.NingboCulture;
import com.lchjy.mapper.CultureMapper;
import com.lchjy.service.CultureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CultureServiceImpl implements CultureService {

    @Autowired
    private CultureMapper cultureMapper;

    @Override
    public List<NingboCulture> list(String keyword) {
        return cultureMapper.selectList(keyword);
    }

    @Override
    public NingboCulture getById(Integer id) {
        return cultureMapper.selectById(id);
    }

    @Override
    public void add(NingboCulture culture) {
        cultureMapper.insert(culture);
    }

    @Override
    public void update(NingboCulture culture) {
        cultureMapper.update(culture);
    }

    @Override
    public void delete(Integer id) {
        cultureMapper.deleteById(id);
    }
}
