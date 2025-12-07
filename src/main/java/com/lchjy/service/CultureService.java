package com.lchjy.service;

import com.lchjy.entity.NingboCulture;
import java.util.List;

public interface CultureService {
    List<NingboCulture> list(String keyword);

    NingboCulture getById(Integer id);

    void add(NingboCulture culture);

    void update(NingboCulture culture);

    void delete(Integer id);
}
